class Splits::Index < BrowserAction
  get "/splits" do
    splits = SplitQuery.new.current_user_splits(user: current_user)
    html Splits::IndexPage, splits: splits
  end
end
