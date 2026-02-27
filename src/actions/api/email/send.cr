class Api::Send < ApiAction
  include Api::Auth::SkipRequireAuthToken

  get "/api/email/send/:send_token" do
    now = Time.local
    if now.end_of_month? && send_token == ENV["SEND_TOKEN"]
      MonthlySplitScheduleQuery.new.send_bill_splits(only_send_every_n_hours: 24)
      json({message: "periodic email hit"})
    else
      json({message: "It's not that time yet"})
    end
  end
end
