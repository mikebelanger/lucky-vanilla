class Splits::DeletePage < MainLayout
  needs operation : Split::DeleteOperation

  def content
    if operation.deleted?
      h1 "Successfully deleted"
    else
      h1 "Error deleting operation: #{operation.inspect}"
    end
  end
end
