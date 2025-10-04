class Purchases::Index < BrowserAction
  get "/purchases" do
    html IndexPage, purchases: PurchaseQuery.new.users_id(current_user.id), partial: true
  end
end
