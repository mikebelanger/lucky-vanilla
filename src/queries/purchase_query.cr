class PurchaseQuery < Purchase::BaseQuery
  def users_purchases_for_month(user : User, from : Time, to : Time)
    PurchaseQuery.new.users_id(user.id)
      .date
      .between(from, to)
  end
end
