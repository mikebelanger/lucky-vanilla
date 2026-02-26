class Api::ManualSendEmail < ApiAction
  include Api::Auth::SkipRequireAuthToken

  get "/api/manual_split_send/:send_token" do
    if send_token == ENV["SEND_TOKEN"]
      MonthlySplitScheduleQuery.new.send_bill_splits(only_send_every_n_hours: 0)
      json({message: "manual split email sent"})
    else
      json({message: "Invalid token"})
    end
  end
end
