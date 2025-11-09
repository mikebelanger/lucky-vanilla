class Splits::Index < BrowserAction
  get "/splits" do
    splits = SplitQuery.new.first_user_id(current_user.id).to_a
    html Splits::IndexPage, splits: splits
  end
end
