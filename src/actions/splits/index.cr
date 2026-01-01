class Splits::Index < BrowserAction
  get "/splits" do
    this_users_splits = [] of Split
    # this_users_split_schedules = MonthlySplitScheduleQuery
    #   .new
    #   .first_user_id(current_user.id)
    #   .or(&.second_user_id(current_user.id))
    #   .each do |split_schedule|
    #     split_schedule.splits.each do |split|
    #       puts "Split: #{split.inspect}"
    #     end
    #   end
    # TODO - find out why the above leads to some weird N+1 queries/feedback loop bug

    SplitQuery.new
      .where_monthly_split_schedule(MonthlySplitScheduleQuery.new.first_user_id(current_user.id))
      .or(&.where_monthly_split_schedule(MonthlySplitScheduleQuery.new.second_user_id(current_user.id)))
      .each do |split|
        this_users_splits << split
      end

    html Splits::IndexPage, splits: this_users_splits
  end
end
