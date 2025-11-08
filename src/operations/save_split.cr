class SaveSplit < Split::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/sawving-records#perma-permitting-columns
  #
  # permit_columns total_amount, paid, paid_on, first_user, second_user
  permit_columns start_day, end_day, total_amount, paid, paid_on, first_user_id, second_user_id, first_user_amount, second_user_amount

  def mark_sent
    @bill_sent_amount += 1
  end
  # def split_for_month(first_email : String, second_email : String, from : Time, to : Time)
  #   first_user = UserQuery.new.email(first_email).first
  #   second_user = UserQuery.new.email(second_email).first
  #   outcome : String = "Undetermined"

  #   unless first_user.nil? || second_user.nil?
  #     first_user_purchases = PurchaseQuery.new.users_purchases_for_month(user: first_user, from: from, to: to)
  #     second_user_purchases = PurchaseQuery.new.users_purchases_for_month(user: second_user, from: from, to: to)

  #     first_total = first_user_purchases.sum(&.dollars)
  #     second_total = second_user_purchases.sum(&.dollars)
  #     total = first_total + second_total

  #     # Create the split record using the SaveOperation instead of direct model creation
  #     # SaveSplit.create!(
  #     #   start_day: from,
  #     #   end_day: to,
  #     #   first_user_id: first_user.id,
  #     #   second_user_id: second_user.id,
  #     #   total_amount: total,
  #     #   paid: false,
  #     #   paid_on: nil
  #     # )
  #     average = total / 2
  #     if first_total > second_total
  #       outcome = "#{second_user.email} owes #{first_user.email}: #{average - second_total}"
  #     elsif first_total < second_total
  #       outcome = "#{first_user.email} owes #{second_user.email}: #{average - first_total}"
  #     else
  #       outcome = "both users spent the same amount"
  #     end
  #   end
  #   {outcome: outcome}
  # end
end
