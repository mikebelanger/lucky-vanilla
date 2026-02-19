class Api::SendEmail < ApiAction
  include Api::Auth::SkipRequireAuthToken

  get "/api/send_email/:send_token" do
    now = Time.now
    if now.end_of_month? && send_token == ENV["SEND_TOKEN"]
      MonthlySplitScheduleQuery.new.send_bill_splits(only_send_every_n_hours: 24)
      json({message: "periodic email hit"})
    else
      json({message: "It's not that time yet"})
    end
  end

  get "/api/manual_split_send/:send_token" do
    if send_token == ENV["SEND_TOKEN"]
      MonthlySplitScheduleQuery.new.send_bill_splits(only_send_every_n_hours: 0)
      json({message: "manual split email sent"})
    else
      json({message: "Invalid token"})
    end
  end
end
