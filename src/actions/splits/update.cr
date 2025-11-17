class Splits::Update < BrowserAction
  put "/splits/:split_id" do
    split = SplitQuery.find(split_id)

    if split
      SaveSplit.update(split, params) do |operation, updated_split|
        html Splits::EditPage, editing: !operation.saved?, split: split
      end
    else
      raise Lucky::RouteNotFoundError.new(context)
    end
  end
end
