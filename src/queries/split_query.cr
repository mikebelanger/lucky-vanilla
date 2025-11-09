class SplitQuery < Split::BaseQuery
  def current_user_splits(user : User)
    self.first_user_id(user.id).or(&.second_user_id(user.id)).to_a
  end
end
