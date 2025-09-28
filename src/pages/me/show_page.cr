class Me::ShowPage
  include Lucky::HTMLPage
  def render
    js_link asset("NewPurchase.js"), defer: "false"
    tag("new-purchase")
  end
end
