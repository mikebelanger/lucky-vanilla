class Purchases::New < BrowserAction
  get "/purchases/new" do
    html NewPage, operation: SavePurchase.new
  end
end
