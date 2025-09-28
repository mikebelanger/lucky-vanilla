class Purchases::ShowPage < MainLayout
  needs purchase : Purchase
  # quick_def page_title, "Purchase with id: #{purchase.id}"

  def content
    link "Back to all Purchases", to: Purchases::Index
    h1 "Purchase with id: #{purchase.id}"
    render_actions
    render_purchase_fields
  end

  def render_actions
    section do
      link "Edit", to: Purchases::Edit.with(purchase.id)
      text " | "
      link "Delete",
        to: Purchases::Delete.with(purchase.id),
        data_confirm: "Are you sure?"
    end
  end

  def render_purchase_fields
    ul do
      li do
        text "dollars: "
        strong purchase.dollars.to_s
      end
      li do
        text "date: "
        strong purchase.date.to_s
      end
      li do
        text "name: "
        strong purchase.name.to_s
      end
      li do
        text "description: "
        strong purchase.description.to_s
      end
    end
  end
end
