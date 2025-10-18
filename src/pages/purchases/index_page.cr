class Purchases::IndexPage < MainLayout
  needs purchases : PurchaseQuery
  quick_def page_title, "My Purchases"

  def content
    h2 "My Recent Purchases"
    render_purchases
  end

  def render_purchases
    ul do
      purchases
        .group_by { |purchase| {year: purchase.date.year, month: purchase.date.month} }
        .each do |date, purchases|
          h4 do
            text "#{date[:month].month_name}, #{date[:year]}"
          end
          purchases.each do |purchase|
            details(class: "purchase-item") do
              summary(class: "outline", role: "button") do
                span do
                  strong do
                    text "$#{purchase.dollars}"
                  end
                  text " on #{purchase.date}"
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
  end
end
