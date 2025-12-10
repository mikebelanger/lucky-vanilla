class MakeAdminOptionalOnUsers::V20251210132219 < Avram::Migrator::Migration::V1
  def migrate
    # Read more on migrations
    # https://www.luckyframework.org/guides/database/migrations
    #
    make_optional table_for(User), :admin
  end

  def rollback
    make_required table_for(User), :admin
  end
end
