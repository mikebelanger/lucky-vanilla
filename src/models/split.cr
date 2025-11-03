class Split < BaseModel
  table do
    column start_day : Time
    column end_day : Time
    column total_amount : Int32
    column paid : Bool = false
    column paid_on : Time
    belongs_to first_user : User
    belongs_to second_user : User
  end
end
