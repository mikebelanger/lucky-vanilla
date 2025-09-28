class Purchases::Show < BrowserAction
  get "/purchases/:purchase_id" do
    html ShowPage, purchase: PurchaseQuery.find(purchase_id)
  end
end
