class Users::Index < BrowserAction
  get "/users" do
    html Users::IndexPage, user_names: UserQuery.all
  end
end
