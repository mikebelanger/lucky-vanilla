class SaveMonthlySplitSchedule < MonthlySplitSchedule::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/saving-records#perma-permitting-columns
  #
  permit_columns first_user_id, second_user_id

  # upsert_lookup_columns :first_user_id, :second_user_id
end
