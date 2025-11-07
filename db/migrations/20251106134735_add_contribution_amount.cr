class AddContributionAmount::V20251106134735 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Split) do
      add first_user_amount : Int32, default: 0
      add second_user_amount : Int32, default: 0
      add bill_sent_amount : Int16, default: 0
    end
  end

  def rollback
    alter table_for(Split) do
      remove :first_user_amount
      remove :second_user_amount
      remove :bill_sent_amount
    end
  end
end
