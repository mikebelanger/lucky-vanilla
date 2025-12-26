class MonthlySplitSchedule::New < BrowserAction
  get "/monthly_split_schedule/new" do
    email_addresses = UserQuery.all.to_a.map { |user| {user.email, user.id} }
    html MonthlySplitSchedule::CreatePage, operation: SaveMonthlySplitSchedule.new, all_users: email_addresses
  end
end
