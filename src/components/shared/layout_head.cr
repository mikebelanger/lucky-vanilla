class Shared::LayoutHead < BaseComponent
  needs page_title : String
  needs current_user : User?

  def login_status(user : User?)
    if user
      span do
        text "Currently logged in as: #{user.name}"
        strong("( #{user.email} )")
      end
      tag("a", is: "link-to", href: "/sign_out", data_method: "DELETE", flow_id: "sign-out-button") do
        text "Sign out"
      end
    end
  end

  def bright_when_active_link(link_text : String, rest_action : Class)
    if current_page?(rest_action)
      link to: rest_action, class: "active" do
        strong do
          text link_text
        end
      end
    else
      link link_text, to: rest_action
    end
  end

  def render
    head do
      utf8_charset
      title "Vanilla Split Expense Tracking - #{@page_title}"
      csrf_meta_tags
      responsive_meta_tag
      css_link asset("main.css")
      css_link asset("pico.min.css")
      css_link asset("pico.colors.min.css")
      if LuckyEnv.development?
        live_reload_connect_tag
        js_link(asset("LinkTo.js"), type: "module")
        js_link(asset("SplitRowForm.js"), type: "module")
      else
        js_link(asset("main.js"), type: "module")
      end
    end
    nav class: "top-navbar" do
      ul do
        li(class: "new-purchase") do
          if current_user
            bright_when_active_link("My purchases", Purchases::Index)
            bright_when_active_link("New purchase", Purchases::New)
            bright_when_active_link("My splits", Splits::Index)
          end
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
