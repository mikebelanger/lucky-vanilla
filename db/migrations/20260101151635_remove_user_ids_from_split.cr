class RemoveUserIdsFromSplit::V20260101151635 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Split) do
      remove :first_user_id
      remove :second_user_id
    end
  end

  def rollback
    alter table_for(Split) do
      add first_user_id : Int64, fill_existing_with: :nothing
      add second_user_id : Int64, fill_existing_with: :nothing
    end
  end
end
