class Me::ShowPage < MainLayout
  EXPENSE_ID = "expense"

  def content
    js_link asset("SomeComponent.js"), defer: "false"
    expense_container(v: 1)
    tag("some-component")
  end

  private def expense_container(v : Number)
    section(class: "container") do
      fieldset(role: "group") do
        legend("Expense Input")
        expense_input(v: v)
      end
      button(type: "submit", for: EXPENSE_ID) do
        text "Add expense"
      end
    end
  end

  private def expense_input(v : Number)
    form(id: EXPENSE_ID) do
      label(for: "purchase_amount") do
        text "Purchase amount"
      end
      input(id: "purchase_amount", type: "text", value: v, step: "0.01", inputmode: "numeric", pattern: "^\d+$")
      label(for: "input_date") do
        text "Date of purchase"
      end
      input(id: "input_date", type: "date", "aria-label": "date")
    end
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
