class Splits::Delete < BrowserAction
  delete "/splits/:split_id" do
    split = SplitQuery.find(split_id)

    Split::DeleteOperation.delete(split) do |operation, _split|
      html Splits::DeletePage, operation: operation
    end
  end
end
