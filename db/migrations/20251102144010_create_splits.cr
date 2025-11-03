class CreateSplits::V20251102144010 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(Split) do
      primary_key id : Int64
      add start_day : Time
      add end_day : Time
      add total_amount : Int32
      add paid : Bool
      add paid_on : Time
      add_belongs_to first_user : User, on_delete: :cascade
      add_belongs_to second_user : User, on_delete: :cascade
      add_timestamps
    end
  end

  def rollback
    drop table_for(Split)
  end
end
