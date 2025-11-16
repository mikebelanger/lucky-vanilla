class Splits::Edit < BrowserAction
  get "/splits/:split_id/edit" do
    split = SplitQuery.find(split_id)
    html Splits::EditPage, editing: true, split: split
  end
end
