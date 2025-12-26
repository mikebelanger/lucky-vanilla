class MonthlySplitSchedule::CreatePage < MainLayout
  needs operation : SaveMonthlySplitSchedule
  needs all_users : Array(Tuple(String, Int64))

  def content
    h1 "Create Monthly Split Schedule"
    form(action: "/monthly_split_schedule", method: "POST") do
      select_input(operation.first_user_id, label: "First User") do
        options_for_select(operation.first_user_id, select_options: all_users, name: "first_user")
      end
      select_input(operation.second_user_id, label: "Second User") do
        options_for_select(operation.second_user_id, select_options: all_users, name: "second_user")
      end
      input type: "submit", value: "Save"
    end
  end
end
