class Api::SendEmail < ApiAction
  include Api::Auth::SkipRequireAuthToken

  get "/api/send_email" do
    Log.info { "periodic reminder found" }
    payload = {status: "success"}
    json payload
  end
end
