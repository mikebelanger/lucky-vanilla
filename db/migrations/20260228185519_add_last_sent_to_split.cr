class AddLastSentToSplit::V20260228185519 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Split) do
      add bill_last_sent : Time?, fill_existing_with: :nothing
    end
  end

  def rollback
    alter table_for(Split) do
      drop :bill_last_sent
    end
  end
end
