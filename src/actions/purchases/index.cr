class Purchases::Index < BrowserAction
  get "/purchases" do
    html IndexPage, purchases: PurchaseQuery.new
  end
end
