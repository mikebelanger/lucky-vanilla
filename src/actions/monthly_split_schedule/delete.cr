class MonthlySplitSchedule::Delete < BrowserAction
  delete "/monthly_split_schedule/:monthly_split_schedule_id" do
    monthly_split_schedule = MonthlySplitScheduleQuery.find(monthly_split_schedule_id)

    if monthly_split_schedule && current_user.admin?
      DeleteMonthlySplitSchedule.delete!(monthly_split_schedule)
    end
    redirect to: "/monthly_split_schedules"
  end
end
