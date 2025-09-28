class AddPurchaseToUser::V20250927153007 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Purchase) do
      add_belongs_to users : User, on_delete: :cascade
    end
  end

  def rollback
    # alter table_for(User) do
    #   remove has_many :purchases
    # end
    alter table_for(Purchase) do
      remove_belongs_to :users
    end
  end
end
