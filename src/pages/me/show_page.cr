class Me::ShowPage < MainLayout

  def portal(href : String)
    tag("ssr-portal", href: href)
  end

  def content
    js_link asset("SSRPortal.js")
    js_link asset("LinkTo.js")

    main(class: "grid") do
      portal(href: "/purchases/new")
      portal(href: "/purchases")
    end
  end
end
