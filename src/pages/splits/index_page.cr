class Splits::IndexPage < MainLayout
  needs splits : Array(Split)

  def content
    h1 "Splits for #{current_user.email}"
    table do
      thead do
        tr do
          th "Total"
          th "My share"
          th "Number of bills sent"
          th "Start"
          th "End"
          th "Actions"
        end
      end
      tbody do
        splits.each do |split|
          tr do
            td do
              text "$#{split.total_amount}"
            end
            td do
              if current_user.id == split.first_user_id
                text "$#{split.first_user_amount}"
              else
                text "$#{split.second_user_amount}"
              end
            end
            td do
              text split.bill_sent_amount
            end
            td do
              text "#{split.start_day.date_without_time}, #{split.start_day.year}"
            end
            td do
              text "#{split.end_day.date_without_time}, #{split.end_day.year}"
            end
            td do
              a href: "/splits/#{split.id}/edit", class: "btn btn-primary" do
                text "Edit"
              end
              a href: "/splits/#{split.id}", class: "btn btn-danger" do
                text "Delete"
              end
            end
          end
        end
      end
    end
  end
end
