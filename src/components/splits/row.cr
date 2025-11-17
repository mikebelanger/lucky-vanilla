class Splits::Row < BaseComponent
  needs editing : Bool
  needs split : Split
  needs current_user : User

  def render_input_date
    if editing?
      if paid_on = split.paid_on
        input(type: "date", value: paid_on.try(&.date_without_time) || "")
      else
        input(type: "date", value: "")
      end
    else
      if paid_on = split.paid_on
        text "#{paid_on.try(&.date_without_time)}, #{paid_on.try(&.year)}"
      else
        text "Not paid"
      end
    end
  end

  def html_id
    "split_row_#{split.id}"
  end

  def render
    row_class_name = if split.paid_on
                       "paid-bg"
                     else
                       ""
                     end

    tr(class: row_class_name, id: html_id) do
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
        render_input_date
      end
      td do
        text "#{split.start_day.date_without_time}, #{split.start_day.year}"
      end
      td do
        text "#{split.end_day.date_without_time}, #{split.end_day.year}"
      end
      if current_user.admin?
        td do
          if editing?
            a href: "/splits/#{split.id}", is: "link-to", reload_id: html_id, data_method: "PUT" do
              text "Save"
            end
            a href: "/splits/#{split.id}", is: "link-to", reload_id: html_id, data_method: "GET" do
              text "Cancel"
            end
          else
            a href: "/splits/#{split.id}/edit", is: "link-to", reload_id: html_id, data_method: "GET" do
              text "Edit"
            end
          end
          a method: "delete", href: "/splits/#{split.id}", is: "link-to", data_method: "DELETE", data_confirm_message: "Are you sure?" do
            text "Delete"
          end
        end
      end
    end
  end
end
