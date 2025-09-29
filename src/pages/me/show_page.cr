class Me::ShowPage
  include Lucky::HTMLPage

  def render
    js_link asset("NewPurchase.js")
    js_link asset("LinkTo.js")
    tag("new-purchase")
  end
end
