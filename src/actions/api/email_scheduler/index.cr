class Api::SendEmail < ApiAction
  include Api::Auth::SkipRequireAuthToken

  get "/api/send_email" do
    now = Time.utc
    from = Time.utc(now.year, now.month, 1)
    to = Time.utc(now.year, now.month + 1, 1)
    payload = PurchaseQuery.new.split_for_month("mike@mike.com", "alex@someplace.com", from, to)
    json(payload)
  end
end
