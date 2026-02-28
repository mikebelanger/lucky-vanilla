require "html_builder"

class Split < BaseModel
  table do
    column start_day : Time
    column end_day : Time
    column total_amount : Int32
    column paid : Bool = false
    column paid_on : Time?
    column first_user_amount : Int32
    column second_user_amount : Int32
    column bill_sent_amount : Int16 = 0
    column bill_last_sent : Time?
    belongs_to monthly_split_schedule : MonthlySplitSchedule?
  end

  def half
    total_amount / 2
  end

  def user_ids : Tuple(Int64?, Int64?)
    if monthly_split_schedule_id
      monthly_split_schedule = MonthlySplitScheduleQuery.new.id.nilable_eq(monthly_split_schedule_id).first
      first_user_id = monthly_split_schedule.try(&.first_user_id)
      second_user_id = monthly_split_schedule.try(&.second_user_id)
      {first_user_id, second_user_id}
    else
      {nil, nil}
    end
  end

  def month_and_year
    "#{Month.new(start_day.month).name}, #{start_day.year}"
  end

  def monthly_contribution(u : User) : Int32?
    first_user_id, second_user_id = user_ids

    if first_user_id && second_user_id
      user_amount = if first_user_id == u.id
                      first_user_amount
                    elsif second_user_id == u.id
                      second_user_amount
                    else
                      0
                    end
      user_amount
    else
      nil
    end
  end

  def owe(u : User) : Int32?
    this_user = UserQuery.new.find(u.id)
    first_user_id, second_user_id = user_ids

    if first_user_id && second_user_id && this_user
      if user_amount = self.monthly_contribution(this_user)
        user_owes = half - user_amount

        # If the halfway amount is greater than the user's monthly contribution
        if user_owes.positive?
          user_owes.to_i32
        else
          0
        end
      end
    else
      nil
    end
  end

  def html_email_body(to : User) : String
    outcome = "Users not all found"
    email_html = ""
    first_user_id, second_user_id = user_ids
    if first_user_id && second_user_id
      first_user = UserQuery.new.find(first_user_id)
      second_user = UserQuery.new.find(second_user_id)

      if first_user && second_user
        average = total_amount / 2
        if first_user_amount > second_user_amount
          outcome = "#{second_user.name} owes #{first_user.name} #{average - second_user_amount} dollars"
        elsif first_user_amount < second_user_amount
          outcome = "#{first_user.name} owes #{second_user.name}: #{average - first_user_amount} dollars"
        else
          outcome = "Both users spent the same amount"
        end
        email_html = HTML.build do
          doctype
          html(lang: "en-US") do
            head do
              title { "Expense Split Notification" }
            end
            body do
              h1 do
                text "Hello, #{to.name}"
              end
              h3 do
                text "This breaks down total food expenses for "
                strong do
                  text month_and_year
                end
              end
              p do
                text "#{first_user.name} spent: "
                strong do
                  text "$#{first_user_amount}"
                end
              end
              p do
                text "#{second_user.name} spent: "
                strong do
                  text "$#{second_user_amount}"
                end
              end
              p do
                text "Total: "
                strong do
                  text "$#{total_amount}"
                end
              end
              p do
                strong do
                  text outcome
                end
              end
            end
          end
        end
      else
        outcome = "users not found"
      end
    end
    email_html
  end

  def due_to_send_after?(only_send_every_n_hours : Int32) : Bool
    if only_send_every_n_hours > 0
      now = Time.utc
      hours_since_last_bill_sent = (now - (self.bill_last_sent || Time.utc)).hours
      hours_since_last_bill_sent > only_send_every_n_hours
    else
      true
    end
  end

  def send_bill_splits(only_send_every_n_hours : Int32) : Bool
    first_user_id, second_user_id = user_ids
    if first_user_id && second_user_id
      first_user = UserQuery.new.find(first_user_id)
      second_user = UserQuery.new.find(second_user_id)

      if first_user && second_user
        if due_to_send_after?(only_send_every_n_hours)
          [first_user, second_user].each do |recipient|
            bill = BillEmail.new(
              to: Carbon::Address.new(recipient.email),
              split: self,
              to_user: recipient
            )
            bill.deliver
          end
          true
        end
      end
    end
    false
  end
end
