class MonthlySplitSchedule < BaseModel
  table do
    belongs_to first_user : User
    belongs_to second_user : User
    has_many splits : Split?
  end
  # def splits
  #   unless self.splits.nil?
  #     self.splits
  #   end
  #   [] of Split
  # end
end
