class Purchases::New < BrowserAction
  get "/purchases/new" do
    html NewPage, operation: SavePurchase.new(current_user: current_user)
  end
end
