class Purchases::EditPage < MainLayout
  needs operation : SavePurchase
  needs purchase : Purchase

  def content
    link "Back to all Purchases", to: Purchases::Index
    h1 "Edit Purchase with id: #{purchase.id}"
    render_purchase_form(operation)
    a(is: "link-to", href: "/purchases/#{purchase.id}", data_method: "DELETE", data_confirm_message: "Are you sure?") do
      text "Delete"
    end
  end

  def render_purchase_form(op)
    form_for Purchases::Update.with(purchase.id) do
      # Edit fields in src/components/purchases/form_fields.cr
      mount Purchases::FormFields, op

      submit "Update", data_disable_with: "Updating..."
    end
  end
end
