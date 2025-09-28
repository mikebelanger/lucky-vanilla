class CreatePurchases::V20250927145352 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(Purchase) do
      primary_key id : Int64
      add_timestamps
      add dollars : Int16
      add date : Time
      add name : String
      add description : String?
    end
  end

  def rollback
    drop table_for(Purchase)
  end
end
