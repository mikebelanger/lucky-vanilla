enum Month
  January
  February
  March
  April
  May
  June
  July
  August
  September
  October
  November
  December

  def name
    (self - 1).to_s
  end
end

struct Time
  def date_without_time
    "#{self.day_of_week}, #{Month.new(self.month).name} #{self.day}"
  end

  def end_of_month?
    (self + 1.day).month == self.month + 1
  end
end
