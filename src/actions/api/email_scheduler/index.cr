class Api::SendEmail < ApiAction
  include Api::Auth::SkipRequireAuthToken

  get "/api/send_email" do
    now = Time.utc
    from = Time.utc(now.year, now.month, 1)
    to = Time.utc(now.year, now.month + 1, 1)
    first_user = UserQuery.new.email("mike@mike.com").first
    second_user = UserQuery.new.email("alex@someplace.com").first

    if first_user.nil? || second_user.nil?
      json({error: "Users not found"})
    else
      first_user_purchases = PurchaseQuery.new.users_purchases_for_month(user: first_user, from: from, to: to)
      second_user_purchases = PurchaseQuery.new.users_purchases_for_month(user: second_user, from: from, to: to)

      first_total = first_user_purchases.sum(&.dollars)
      second_total = second_user_purchases.sum(&.dollars)

      total = first_total + second_total

      split = SaveSplit.create(
        first_user_id: first_user.id,
        second_user_id: second_user.id,
        start_day: from,
        end_day: to,
        total_amount: total.to_i32,
        paid: false
      ) do |operation, split|
        if split
          # Split created successfully
        end
      end

      average = total / 2
      if first_total > second_total
        outcome = "#{second_user.email} owes #{first_user.email}: #{average - second_total}"
      elsif first_total < second_total
        outcome = "#{first_user.email} owes #{second_user.email}: #{average - first_total}"
      else
        outcome = "both users spent the same amount"
      end
      BillEmail.new(
        recipient: first_user,
        month: Month.new(now.month),
        outcome: outcome)
      .deliver

      json({outcome: outcome, total: total, first_total: first_total, second_total: second_total})
    end
  end
end
