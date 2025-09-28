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
