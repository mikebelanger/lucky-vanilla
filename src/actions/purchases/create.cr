class Purchases::Create < BrowserAction
  post "/purchases" do
    SavePurchase.create(params) do |operation, purchase|
      if purchase
        flash.success = "The record has been saved"
        redirect Show.with(purchase.id)
      else
        flash.failure = "It looks like the form is not valid"
        html NewPage, operation: operation
      end
    end
  end
end
