class Splits::IndexPage < MainLayout
  needs splits : Array(Split)

  def content
    h1 "Splits for #{current_user.email}"
    table do
      thead do
        tr do
          th "Total"
          th "My contribution"
          th "I owe"
          th "Number of bills sent"
          th "Paid on"
          th "Start"
          th "End"
          if current_user.admin?
            th "Actions"
          end
        end
      end
      tbody do
        splits.each do |split|
          mount Splits::Row, editing: false, split: split, current_user: current_user
        end
      end
    end
  end
end
