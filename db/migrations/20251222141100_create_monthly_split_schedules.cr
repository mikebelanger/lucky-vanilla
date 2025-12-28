class CreateMonthlySplitSchedules::V20251222141100 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(MonthlySplitSchedule) do
      primary_key id : Int64
      add_timestamps
      add first_user_id : Int64
      add second_user_id : Int64
    end
  end

  def rollback
    drop table_for(MonthlySplitSchedule)
  end
end
