class Shared::LayoutHead < BaseComponent
  needs page_title : String
  needs current_user : User?

  def login_status(user : User?)
    if user
      text "Currently logged in as: #{user.email}"
      tag("a", is: "link-to", href: "/sign_out", dataMethod: "DELETE", flow_id: "sign-out-button") do
        text "Sign out"
      end
    end
  end

  def render
    head do
      utf8_charset
      title "My App - #{@page_title}"
      css_link asset("main.css")
      css_link asset("pico.min.css")
      css_link asset("pico.colors.min.css")
      csrf_meta_tags
      responsive_meta_tag

      # Development helper used with the `lucky watch` command.
      # Reloads the browser when files are updated.
      live_reload_connect_tag if LuckyEnv.development?
    end
    section class: "content" do
      nav do
        ul do
          li do
            strong
              text "Expense Tracker"
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
end
