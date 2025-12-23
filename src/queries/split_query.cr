class SplitQuery < Split::BaseQuery
  # def current_user_splits(user : User, schedule : MonthlySplitSchedule)
  #   [] of Split
  # end
  def splits
  end
end
# self.monthly_split_schedule_id(schedule.id).first_user_id(user.id).or(&.second_user_id(user.id)).to_a
