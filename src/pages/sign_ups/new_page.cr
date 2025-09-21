class SignUps::NewPage < AuthLayout
  needs operation : SignUpUser

  def content
    main class: "container" do
      h1 "Sign Up"
      render_sign_up_form(@operation)
    end
  end

  private def render_sign_up_form(op)
    form_for SignUps::Create do
      sign_up_fields(op)
      submit "Sign Up", flow_id: "sign-up-button"
      link "Sign in instead", to: SignIns::New
    end
  end

  private def sign_up_fields(op)
    fieldset do
      mount Shared::Field, attribute: op.email, &.email_input(autofocus: "true")
      mount Shared::Field, attribute: op.password, &.password_input
      mount Shared::Field, attribute: op.password_confirmation, &.password_input
    end
  end
end
