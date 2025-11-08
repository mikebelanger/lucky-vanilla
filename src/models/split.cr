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
    belongs_to first_user : User
    belongs_to second_user : User
  end

  def outcome
    outcome = "some outcome"
    first_user = UserQuery.new.find(first_user_id)
    second_user = UserQuery.new.find(second_user_id)

    if first_user && second_user
      average = first_user_amount / 2
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
    outcome
  end
end
