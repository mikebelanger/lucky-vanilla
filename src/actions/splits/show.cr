class Splits::Show < BrowserAction
  get "/splits/:split_id" do
    split = SplitQuery.find(split_id)
    html Splits::EditPage, editing: false, split: split
  end
end
