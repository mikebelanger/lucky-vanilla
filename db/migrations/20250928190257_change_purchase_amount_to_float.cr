class ChangePurchaseAmountToFloat::V20250928190257 < Avram::Migrator::Migration::V1
  def migrate
    # Read more on migrations
    # https://www.luckyframework.org/guides/database/migrations
    #
    alter table_for(Purchase) do
      change_type dollars : Float64
    end

    # Run custom SQL with execute
    #
    # execute "CREATE UNIQUE INDEX things_title_index ON things (title);"
  end

  def rollback
    alter table_for(Purchase) do
      change_type dollars : Int16
    end
  end
end
