class MonthlySplitScheduleQuery < MonthlySplitSchedule::BaseQuery
  def splits
    unless self.splits.nil?
      self.splits
    end
    [] of Split
  end
end
