class Split < BaseModel
  table do
    column start_day : Time
    column end_day : Time
    column total_amount : Int32
    column paid : Bool = false
    column paid_on : Time?
    column first_user_amount : Int32
    column second_user_amount : Int32
    column bill_sent_amount : Int16
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

  def outcome
    outcome = "Users not all found"
    first_user_id, second_user_id = user_ids
    if first_user_id && second_user_id
      first_user = UserQuery.new.find(first_user_id)
      second_user = UserQuery.new.find(second_user_id)

      if first_user && second_user
        average = total_amount / 2
        if first_user_amount > second_user_amount
          outcome = "#{second_user.email} owes #{first_user.email}: #{average - second_user_amount}"
        elsif first_user_amount < second_user_amount
          outcome = "#{first_user.email} owes #{second_user.email}: #{average - first_user_amount}"
        else
          outcome = "both users spent the same amount"
        end
      else
        outcome = "users not found"
      end
    end
    outcome
  end
end
