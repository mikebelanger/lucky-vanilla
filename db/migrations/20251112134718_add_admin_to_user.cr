class AddAdminToUser::V20251112134718 < Avram::Migrator::Migration::V1
  def migrate
    # Read more on migrations
    # https://www.luckyframework.org/guides/database/migrations
    #
    alter table_for(User) do
      add admin : Bool, default: false
    end
  end

  def rollback
    alter table_for(User) do
      drop :admin
    end
  end
end
