class Purchases::Edit < BrowserAction
  get "/purchases/:purchase_id/edit" do
    purchase = PurchaseQuery.find(purchase_id)
    html EditPage,
      operation: SavePurchase.new(purchase),
      purchase: purchase
  end
end
