class Splits::Create < BrowserAction
  post "/splits/create" do
    pp "params: #{params.inspect}"
    plain_text "stuff"
  end
end
