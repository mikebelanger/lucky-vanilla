class MonthlySplitSchedules::IndexPage < MainLayout
  needs split_schedules : MonthlySplitScheduleQuery

  def content
    h1 "Monthly Split Schedules"
    ul do
      split_schedules.each do |split_schedule|
        li do
          text "Between #{UserQuery.find(split_schedule.first_user_id).name} and #{UserQuery.find(split_schedule.second_user_id).name}"
          if current_user.admin?
            a method: "delete", reload_id: split_schedule.id, href: "/monthly_split_schedule/#{split_schedule.id}", is: "link-to", data_method: "DELETE", data_confirm_message: "Are you sure?" do
              text "Delete"
            end
          end
        end
      end
    end
  end
end
