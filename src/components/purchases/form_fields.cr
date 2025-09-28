class Purchases::FormFields < BaseComponent
  needs operation : SavePurchase

  def render
    number_input operation.dollars, autofocus: "true", step: "0.01"
    date_input operation.date, default: Time.utc.to_s
    mount Shared::Field, operation.name
    mount Shared::Field, operation.description
  end
end
