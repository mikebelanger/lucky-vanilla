class Splits::Index < BrowserAction
  get "/splits" do
    # this_users_splits = [] of Split
    # this_users_split_schedules = MonthlySplitScheduleQuery.new.first_user_id(current_user.id).or(&.second_user_id(current_user.id)).each do |split_schedule|
    #   this_users_splits << SplitQuery.new.current_user_splits(user: current_user, schedule: split_schedule).to_a
    # end
    html Splits::IndexPage, splits: [] of Split
  end
end
