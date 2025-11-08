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

      SaveSplit.create(
        first_user_id: first_user.id,
        second_user_id: second_user.id,
        start_day: from,
        end_day: to,
        total_amount: total.to_i32,
        paid: false,
        first_user_amount: first_total.to_i32,
        second_user_amount: second_total.to_i32,
        bill_sent_amount: 0,
      ) do |operation, split|
        if split
          # Split created successfully
          bill = BillEmail.new(
            recipient: first_user,
            split: split
          )

          bill.deliver
          json({message: "Email sent: #{split.outcome}"})
        else
          json({message: "Message not sent successfully"})
        end
      end
    end
  end
end
