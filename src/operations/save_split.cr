class SaveSplit < Split::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/sawving-records#perma-permitting-columns
  #
  # permit_columns total_amount, paid, paid_on, first_user, second_user
  permit_columns start_day, end_day, total_amount, paid, paid_on, first_user_amount, second_user_amount

  upsert_lookup_columns :first_user_id, :second_user_id, :paid, :start_day, :end_day

  def mark_sent
    @bill_sent_amount += 1
  end
end
