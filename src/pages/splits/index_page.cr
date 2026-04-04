class Splits::IndexPage < MainLayout
  needs splits : Array(Split)

  def content
    splits_table_body_id = "splits_table_body"

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
            th(colspan: "2") do
              text "Actions"
            end
          end
        end
      end
      tbody id: splits_table_body_id do
        splits
          .sort { |a, b| (b.start_day - a.start_day).days.to_i32 }
          .each do |split|
            mount Splits::Row, editing: false, split: split, current_user: current_user
          end
      end
    end
  end
end
