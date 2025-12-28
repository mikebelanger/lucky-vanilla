class MonthlySplitSchedule::CreatePage < MainLayout
  needs operation : SaveMonthlySplitSchedule
  needs all_users : Array(Tuple(String, Int64))

  def content
    h1 "Create Monthly Split Schedule"
    form_for MonthlySplitSchedule::Create do
      select_input(operation.first_user_id, label: "First User") do
        select_prompt("Please select the first user")
        options_for_select(operation.first_user_id, select_options: all_users, name: "first_user_id")
      end
      select_input(operation.second_user_id, label: "Second User") do
        select_prompt("Please select the second user")
        options_for_select(operation.second_user_id, select_options: all_users, name: "second_user_id")
      end
      input type: "submit", value: "Save"
    end
  end
end
