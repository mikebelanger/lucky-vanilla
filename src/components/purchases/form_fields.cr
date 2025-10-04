class Purchases::FormFields < BaseComponent
  needs operation : SavePurchase

  def render
    # Purchase Amount
    label_for(operation.dollars)
    number_input operation.dollars, autofocus: "true", step: "0.01"

    # Purchase Date
    label_for(operation.date)
    date_input operation.date, default: Time.utc.to_s

    # Give it a name for easy reference
    mount Shared::Field, operation.name

    # Any additional data you might want to add
    # ie) list of items purchased, what its for, etc
    mount Shared::Field, operation.description
  end
end
