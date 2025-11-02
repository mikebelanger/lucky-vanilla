class Api::SendEmail < ApiAction
  include Api::Auth::SkipRequireAuthToken

  get "/api/send_email" do
    now = Time.utc
    from = Time.utc(now.year, now.month, 1)
    to = Time.utc(now.year, now.month + 1, 1)
    payload = PurchaseQuery.new.split_for_month("mike@mike.com", "alex@someplace.com", from, to)
    user = UserQuery.new.email("alex@someplace.com").first
    BillEmail.new(
      recipient: user,
      month: Month.new(now.month),
      outcome: payload[:outcome])
    .deliver

    json(payload)
  end
end
