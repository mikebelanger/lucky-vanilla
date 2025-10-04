class Purchases::IndexPage < MainLayout
  needs purchases : PurchaseQuery
  quick_def page_title, "All Purchases"

  def content
    h1 "All Purchases"
    link "New Purchase", to: Purchases::New
    render_purchases
  end

  def partial_link(
      text : String,
      to : Lucky::RouteHelper,
      resource_id : Int64,
      reload_element_id : String,
      attrs : Array(Symbol) = [] of Symbol,
      **html_options
    ) : Nil

    tag("a", is: "link-to", href: "/purchases/#{resource_id}/?partial=true", dataMethod: "GET", resourceId: resource_id, reloadId: "purchases-island") do
      text text
    end
  end

  def render_purchases
    ul(id: "purchases-island") do
      purchases.each do |purchase|
        li do
          partial_link purchase.dollars.to_s, to: Purchases::Show.with(purchase), resource_id: purchase.id, reload_element_id: "purchases"
        end
      end
    end
  end
end
