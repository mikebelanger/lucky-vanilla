class PurchaseQuery < Purchase::BaseQuery
  def users_purchases_for_month(user : User, from : Time, to : Time)
    PurchaseQuery.new.users_id(user.id)
      .date
      .between(from, to)
  end

  def split_for_month(first_email : String, second_email : String, from : Time, to : Time)
    first_user = UserQuery.new.email(first_email).first
    second_user = UserQuery.new.email(second_email).first
    outcome : String = "Undetermined"

    unless first_user.nil? || second_user.nil?
      first_user_purchases = PurchaseQuery.new.users_purchases_for_month(user: first_user, from: from, to: to)
      second_user_purchases = PurchaseQuery.new.users_purchases_for_month(user: second_user, from: from, to: to)

      first_total = first_user_purchases.sum(&.dollars)
      second_total = second_user_purchases.sum(&.dollars)
      total = first_total + second_total
      average = total / 2
      if first_total > second_total
        outcome = "#{second_user.email} owes #{first_user.email}: #{average - second_total}"
      elsif first_total < second_total
        outcome = "#{first_user.email} owes #{second_user.email}: #{average - first_total}"
      else
        outcome = "both users spent the same amount"
      end
    end
    {outcome: outcome}
  end
end
