class Purchases::FormFields < BaseComponent
  needs operation : SavePurchase

  def render
    mount Shared::Field, operation.dollars, &.text_input(autofocus: "true")
    mount Shared::Field, operation.date
    mount Shared::Field, operation.name
    mount Shared::Field, operation.description
  end
end
