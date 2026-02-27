require "spec"
require "../../src/utils/time_extend"

describe Time do
  # split = Split.new(
  #   id: 0.to_i64,
  #   created_at: Time.utc - 5.hours,
  #   updated_at: Time.utc - 2.hours,
  #   start_day: Time.utc,
  #   total_amount: 10,
  #   paid: false,
  #   paid_on: nil,
  #   first_user_amount: 0,
  #   second_user_amount: 10,
  #   bill_sent_amount: 1.to_i16,
  #   end_day: Time.utc,
  #   monthly_split_schedule_id: 0.to_i64,
  # )

  describe "#end_of_month?" do
    it "returns true if the day is the last day of the month" do
      (Time.utc(2022, 1, 31).end_of_month?).should be_true
    end

    it "returns false if the day is not the last day of the month" do
      (Time.utc(2022, 1, 30).end_of_month?).should be_false
    end

    it "returns false if the day is not the last day of the month" do
      (Time.utc(2025, 2, 25).end_of_month?).should be_false
    end
  end
end
