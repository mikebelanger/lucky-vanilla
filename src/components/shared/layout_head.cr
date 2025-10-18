class Shared::LayoutHead < BaseComponent
  needs page_title : String
  needs current_user : User?

  def login_status(user : User?)
    if user
      span do
        text "Currently logged in as: #{user.name}"
        strong("( #{user.email} )")
      end
      tag("a", is: "link-to", href: "/sign_out", dataMethod: "DELETE", flow_id: "sign-out-button") do
        text "Sign out"
      end
    end
  end

  def render
    head do
      utf8_charset
      title "My App - #{@page_title}"
      csrf_meta_tags
      responsive_meta_tag
      css_link asset("main.css")
      css_link asset("pico.min.css")
      css_link asset("pico.colors.min.css")
      js_link asset("LinkTo.js")

      live_reload_connect_tag if LuckyEnv.development?
    end
    nav class: "top-navbar" do
      ul do
        li(class: "new-purchase") do
          link "Add Purchase Entry", to: Purchases::New
        end
      end
      ul do
        li id: "sign_out_section" do
          login_status current_user
        end
      end
    end
  end
end
