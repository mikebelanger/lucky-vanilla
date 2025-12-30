class MonthlySplitSchedule::Create < BrowserAction
  post "/monthly_split_schedules" do
    SaveMonthlySplitSchedule.upsert(params) do |operation, schedule|
      if schedule
        puts "operation successful"
      else
        puts "operation failed: #{operation.inspect}"
      end
    end
    redirect "/monthly_split_schedule"
  end
end
