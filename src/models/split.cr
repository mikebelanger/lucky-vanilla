class Split < BaseModel
  table do
    column start_day : Time
    column end_day : Time
    column total_amount : Int32
    column paid : Bool = false
    column paid_on : Time?
    column first_user_amount : Int32
    column second_user_amount : Int32
    column bill_sent_amount : Int16
    belongs_to first_user : User
    belongs_to second_user : User
  end
end
