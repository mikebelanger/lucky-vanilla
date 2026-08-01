class PasswordResetRequests::Create < BrowserAction
  include Auth::RedirectSignedInUsers

  post "/password_reset_requests" do
    RequestPasswordReset.run(params) do |operation, user|
      # Ensure password reset does not become a path to exploit DDoS
      if user
        current_time = Time.utc
        password_last_reset_time = user.password_last_reset || Time.utc
        time_since_last_reset = current_time - password_last_reset_time
        user_update_op = User::SaveOperation.new(user)

        if time_since_last_reset > 12.hours
          user_update_op.password_reset_count.value = 0
          user_update_op.password_last_reset.value = Time.utc
          user_update_op.save!

          PasswordResetRequestEmail.new(user).deliver
          flash.success = "You should receive an email on how to reset your password shortly"
          redirect SignIns::New

          # Limit it to 6 emails
        else
          if user && time_since_last_reset < 12.hours
            if user.password_reset_count < 6
              PasswordResetRequestEmail.new(user).deliver

              updated_password_reset_count = user.password_reset_count + 1
              user_update_op.password_reset_count.value = updated_password_reset_count
              user_update_op.password_last_reset.value = Time.utc
              user_update_op.save!

              flash.success = "You should receive an email on how to reset your password shortly"
              redirect SignIns::New
            else
              flash.failure = "You have exceeded the number of password attempts within this 12 hour period. Try again after 12 hours."
              redirect SignIns::New
            end
          else
            html NewPage, operation: operation
          end
        end
      else
        flash.failure = "Error, unable to find user"
        redirect SignIns::New
      end
    end
  end
end
