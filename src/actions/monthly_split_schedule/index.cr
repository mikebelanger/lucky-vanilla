class MonthlySplitSchedule::Index < BrowserAction
  get "/monthly_split_schedule" do
    split_schedules = MonthlySplitScheduleQuery.new
    html MonthlySplitSchedules::IndexPage, split_schedules: split_schedules
  end
end
