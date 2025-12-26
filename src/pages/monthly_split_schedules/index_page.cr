class MonthlySplitSchedules::IndexPage < MainLayout
  needs split_schedules : MonthlySplitScheduleQuery

  def content
    h1 "Monthly Split Schedules"
    ul do
      split_schedules.each do |split_schedule|
        li do
          text split_schedule.inspect
        end
      end
    end
  end
end
