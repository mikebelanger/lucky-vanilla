class Splits::EditPage
  include Lucky::HTMLPage

  needs editing : Bool
  needs split : Split
  needs current_user : User

  def render
    mount Splits::Row, editing: editing?, split: split, current_user: current_user
  end
end
