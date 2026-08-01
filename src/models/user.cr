class User < BaseModel
  include Carbon::Emailable
  include Authentic::PasswordAuthenticatable

  table do
    column email : String
    column encrypted_password : String
    column name : String
    has_many purchases : Purchase
    column admin : Bool? = false
    column password_reset_count : Int64 = 0
    column password_last_reset : Time? = nil
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end
end
