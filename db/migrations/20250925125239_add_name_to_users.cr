class AddNameToUsers::V20250925125239 < Avram::Migrator::Migration::V1
  def migrate
    # Read more on migrations
    # https://www.luckyframework.org/guides/database/migrations
    #
    alter table_for(User) do
      add name : String, default: "New username"
    end

    # Run custom SQL with execute
    #
    # execute "CREATE UNIQUE INDEX things_title_index ON things (title);"
  end

  def rollback
    alter table_for(User) do
      remove :name
    end
  end
end
