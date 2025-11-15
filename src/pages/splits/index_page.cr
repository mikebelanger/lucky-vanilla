class Splits::IndexPage < MainLayout
  needs splits : Array(Split)

  def content
    h1 "Splits for #{current_user.email}"
    table do
      thead do
        tr do
          th "Total"
          th "My contribution"
          th "I owe"
          th "Number of bills sent"
          th "Paid on"
          th "Start"
          th "End"
          if current_user.admin?
            th "Actions"
          end
        end
      end
      tbody do
        splits.each do |split|
          paid_on = split.paid_on

          row_class_name = if paid_on
                             "paid-bg"
                           else
                             ""
                           end
          tr(class: row_class_name) do
            td do
              text "$#{split.total_amount}"
            end
            td do
              text "$#{split.monthly_contribution(current_user)}"
            end
            td do
              text "$#{split.owe(current_user)}"
            end
            td do
              text split.bill_sent_amount
            end
            td do
              if paid_on
                text "#{paid_on.date_without_time}, #{paid_on.year}"
              else
                text "Not paid"
              end
            end
            td do
              text "#{split.start_day.date_without_time}, #{split.start_day.year}"
            end
            td do
              text "#{split.end_day.date_without_time}, #{split.end_day.year}"
            end
            if current_user.admin?
              td do
                a href: "/splits/#{split.id}/edit", class: "btn btn-primary" do
                  text "Edit"
                end
                a method: "delete", href: "/splits/#{split.id}", is: "link-to", data_method: "DELETE", data_confirm_message: "Are you sure?" do
                  text "Delete"
                end
              end
            end
          end
        end
      end
    end
  end
end
