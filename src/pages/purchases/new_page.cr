class Purchases::NewPage < MainLayout
  needs operation : SavePurchase
  quick_def page_title, "New Purchase"

  def content
    h1 "New Purchase"
    render_purchase_form(operation)
  end

  def render_purchase_form(op)
    form_for Purchases::Create do
      # Edit fields in src/components/purchases/form_fields.cr
      mount Purchases::FormFields, op

      submit "Save", data_disable_with: "Saving..."
    end
  end
end
