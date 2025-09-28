class Users::Index < BrowserAction
  get "/users" do
    html Users::IndexPage, user_names: ["user_1", "user_2"]
  end
end
