class SaveMonthlySplitSchedule < MonthlySplitSchedule::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/saving-records#perma-permitting-columns
  #
  permit_columns first_user_id, second_user_id

  upsert_lookup_columns :first_user_id, :second_user_id

  before_save do
    check_doubles
    validate_users_uniqueness
  end

  def validate_users_uniqueness
    first_id = first_user_id.value
    second_id = second_user_id.value
    split_query = MonthlySplitScheduleQuery.new

    if first_id && second_id
      already_existing_arrangements_between_these_users = split_query
        .first_user_id(first_id)
        .second_user_id(second_id)
        .or(&.first_user_id(second_id).second_user_id(first_id))

      unless already_existing_arrangements_between_these_users.empty?
        first_user_id.add_error("Users are already split")
      end
    end
  end

  def check_doubles
    first_id = first_user_id.value
    second_id = second_user_id.value

    if first_id && second_id && first_id === second_id
      first_user_id.add_error("First user is the same as the second user")
    end
  end
end
