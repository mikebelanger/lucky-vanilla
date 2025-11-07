class AddNullishToPaidOn::V20251107114408 < Avram::Migrator::Migration::V1
  def migrate
    # Read more on migrations
    # https://www.luckyframework.org/guides/database/migrations
    #
    make_optional table_for(Split), :paid_on
  end

  def rollback
    make_required table_for(Split), :paid_on
  end
end
