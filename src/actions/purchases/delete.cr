class Purchases::Delete < BrowserAction
  delete "/purchases/:purchase_id" do
    purchase = PurchaseQuery.find(purchase_id)
    DeletePurchase.delete(purchase) do |_operation, _deleted|
      flash.success = "Deleted the purchase"
      redirect Index
    end
  end
end
