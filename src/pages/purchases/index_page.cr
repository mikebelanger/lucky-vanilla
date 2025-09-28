class Purchases::IndexPage < MainLayout
  needs purchases : PurchaseQuery
  quick_def page_title, "All Purchases"

  def content
    h1 "All Purchases"
    link "New Purchase", to: Purchases::New
    render_purchases
  end

  def render_purchases
    ul do
      purchases.each do |purchase|
        li do
          link purchase.dollars.to_s, to: Purchases::Show.with(purchase)
        end
      end
    end
  end
end
