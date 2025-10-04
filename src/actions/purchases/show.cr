class Purchases::Show < BrowserAction
  get "/purchases/:purchase_id/?:partial" do
    if partial
      html Purchases::ShowPage, purchase: PurchaseQuery.find(purchase_id), partial: true
    else
      html Purchases::ShowPage, purchase: PurchaseQuery.find(purchase_id), partial: false
    end
  end
end
