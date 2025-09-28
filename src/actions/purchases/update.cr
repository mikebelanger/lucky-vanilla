class Purchases::Update < BrowserAction
  put "/purchases/:purchase_id" do
    purchase = PurchaseQuery.find(purchase_id)
    SavePurchase.update(purchase, params, current_user: current_user) do |operation, updated_purchase|
      if operation.saved?
        flash.success = "The record has been updated"
        redirect Show.with(updated_purchase.id)
      else
        flash.failure = "It looks like the form is not valid"
        html EditPage, operation: operation, purchase: updated_purchase
      end
    end
  end
end
