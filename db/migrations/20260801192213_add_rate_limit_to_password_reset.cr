class AddRateLimitToPasswordReset::V20260801192213 < Avram::Migrator::Migration::V1
  def migrate
    # Read more on migrations
    # https://www.luckyframework.org/guides/database/migrations
    #
    alter table_for(User) do
      add password_reset_count : Int64, default: 0
      add password_last_reset : Time?, default: nil
    end

    # Run custom SQL with execute
    #
    # execute "CREATE UNIQUE INDEX things_title_index ON things (title);"
  end

  def rollback
    alter table_for(User) do
      remove :password_reset_count
      remove :password_last_reset
    end
  end
end
