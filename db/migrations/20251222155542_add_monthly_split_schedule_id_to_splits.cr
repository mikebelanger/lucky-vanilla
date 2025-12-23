class AddMonthlySplitScheduleIdToSplits::V20251222155542 < Avram::Migrator::Migration::V1
  def migrate
    alter :splits do
      add_belongs_to monthly_split_schedule : MonthlySplitSchedule?, on_delete: :nullify
    end
  end

  def rollback
    alter :splits do
      remove_belongs_to :monthly_split_schedule
    end
  end
end
