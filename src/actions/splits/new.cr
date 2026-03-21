class Splits::New < BrowserAction
  get "/splits/new" do
    html Splits::CreateRow
  end
end
