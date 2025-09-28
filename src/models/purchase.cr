class Purchase < BaseModel
  table do
    column dollars : Int16
    column date : Time
    column name : String
    column description : String?
    belongs_to : User
  end
end
