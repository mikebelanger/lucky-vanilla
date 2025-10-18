class Me::Show < BrowserAction
  get "/me" do
    html Purchases::IndexPage, purchases: PurchaseQuery.new.users_id(current_user.id)
  end
end
