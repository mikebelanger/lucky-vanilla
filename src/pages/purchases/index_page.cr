class Purchases::IndexPage < MainLayout
  needs purchases : PurchaseQuery
  quick_def page_title, "My Purchases"

  def content
    render_purchases
  end

  def render_purchases
    ul(class: "container") do
      purchases
        .to_a
        .sort! { |purchase_a, purchase_b| (purchase_b.date.year + purchase_b.date.month) <=> (purchase_a.date.year + purchase_a.date.month) }
        .group_by { |purchase| {year: purchase.date.year, month: purchase.date.month} }
        .each do |date, purchases|
          h4 do
            text "#{Month.new(date[:month]).name} #{date[:year]}"
          end
          hr
          purchases
            .sort { |purchase_a, purchase_b| purchase_a.date.day <=> purchase_b.date.day }
            .each do |purchase|
              details(class: "purchase-item") do
                summary(class: "outline", role: "button") do
                  span do
                    strong do
                      text "$#{purchase.dollars}"
                    end
                    text " on #{purchase.date.date_without_time}"
                  end
                end
                if description = purchase.description
                  span description
                end
                link "Edit Purchase", to: Purchases::Edit.with(purchase), resource_id: purchase.id, reload_element_id: "purchases"
              end
            end
        end
    end
    div class: "add-split" do
      link to: Purchases::New, title: "Add new purchase"
    end
  end
end
