class Purchases::EditPage < MainLayout
  needs operation : SavePurchase
  needs purchase : Purchase
  quick_def page_title, "Edit Purchase with id: #{purchase.id}"

  def content
    link "Back to all Purchases", to: Purchases::Index
    h1 "Edit Purchase with id: #{purchase.id}"
    render_purchase_form(operation)
  end

  def render_purchase_form(op)
    form_for Purchases::Update.with(purchase.id) do
      # Edit fields in src/components/purchases/form_fields.cr
      mount Purchases::FormFields, op

      submit "Update", data_disable_with: "Updating..."
    end
  end
end
