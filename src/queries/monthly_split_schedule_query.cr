class MonthlySplitScheduleQuery < MonthlySplitSchedule::BaseQuery
  def splits
    unless self.splits.nil?
      self.splits
    end
    [] of Split
  end

  def send_bill_splits(only_send_every_n_hours : Int32 = 24)
    now = Time.utc
    from = Time.utc(now.year, now.month, 1)
    to = (from + 1.month) - 1.day

    # Query all Monthly Split Schedules
    self
      .to_a
      .select { |split_schedule| split_schedule.first_user_id && split_schedule.second_user_id }
      .each do |split_schedule|
        first_user_id = split_schedule.first_user_id
        second_user_id = split_schedule.second_user_id

        first_user = UserQuery.find(first_user_id)
        second_user = UserQuery.find(second_user_id)

        first_user_purchases = PurchaseQuery.new.users_purchases_for_month(user: first_user, from: from, to: to)
        second_user_purchases = PurchaseQuery.new.users_purchases_for_month(user: second_user, from: from, to: to)

        first_total = first_user_purchases.sum(&.dollars)
        second_total = second_user_purchases.sum(&.dollars)
        total = first_total + second_total

        # Query SaveSplit for existing splits first
        any_existing_splits = SplitQuery.new
          .monthly_split_schedule_id(split_schedule.id)
          .paid(false)
          .start_day(from)
          .end_day(to)

        if any_existing_splits.empty?
          SaveSplit.create(
            monthly_split_schedule_id: split_schedule.id,
            paid: false,
            start_day: from,
            end_day: to,
            first_user_amount: first_total.to_i32,
            second_user_amount: second_total.to_i32,
            total_amount: total.to_i32,
            bill_sent_amount: 0,
          ) do |operation, split|
            if split && operation.created?
              split.send_bill_splits(only_send_every_n_hours)
            else
              Log.info { "Failed to create split: #{operation.inspect} \n split: #{split.inspect}" }
            end
          end
        else
          any_existing_splits.each do |existing_split|
            SaveSplit.update(existing_split,
              first_user_amount: first_total.to_i32,
              second_user_amount: second_total.to_i32,
              total_amount: total.to_i32
            ) do |_operation, updated_split|
              updated_split.send_bill_splits(only_send_every_n_hours)
            end
          end
        end
      end
  end
end
