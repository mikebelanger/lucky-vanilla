class MonthlySplitSchedule::Create < BrowserAction
  post "/monthly_split_schedules" do
    SaveMonthlySplitSchedule.upsert(params) do |operation, schedule|
      if operation.saved?
        flash.success
        redirect "/monthly_split_schedule"
      else
        flash.failure
        html NewPage, operation: operation
      end
    end
  end
end
