class Purchase < BaseModel
  table do
    column dollars : Float64
    column date : Time
    column name : String
    column description : String?
    belongs_to users : User
  end
end
