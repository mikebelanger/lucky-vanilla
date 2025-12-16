class Api::SendEmail < ApiAction
  include Api::Auth::SkipRequireAuthToken

  get "/api/send_email" do
    now = Time.utc
    from = Time.utc(now.year, now.month, 1)
    to = from + 1.month
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

      SaveSplit.upsert(
        first_user_id: first_user.id,
        second_user_id: second_user.id,
        paid: false,
        start_day: from,
        end_day: to,
        first_user_amount: first_total.to_i32,
        second_user_amount: second_total.to_i32,
        total_amount: total.to_i32
      ) do |operation, split|
        if operation.created?
          puts "This one is new"
        else
          puts "This one is an update"
        end

        if split
          bill = BillEmail.new(
            recipient: first_user,
            split: split
          )
          bill.deliver
        end
      end
      json({message: "Mail sending finished"})
    end
  end
end
