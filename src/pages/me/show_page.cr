class Me::ShowPage < MainLayout
  def content
    js_link asset("SomeComponent.js"), defer: "false"
    h3 "Email:  #{@current_user.email}"
    helpful_tips
    tag("some-component")
  end


  private def helpful_tips
    h3 "Next, you may want to:"
    ul do
      li { link_to_authentication_guides }
      li "Modify this page: src/pages/me/show_page.cr"
      li "Change where you go after sign in: src/actions/home/index.cr"
    end
  end

  private def link_to_authentication_guides
    a(href: "https://luckyframework.org/guides/authentication") do
      text "Check out the authentication guides"
    end
  end
end
