class BillEmail < BaseEmail
  # Read more on emails
  # https://luckyframework.org/guides/emails/sending-emails-with-carbon
  #
  # Send this email with:
  # ```
  # recipient = UserQuery.first
  # BillEmail.new(recipient).deliver
  # ```

  def initialize(@recipient : Carbon::Emailable, @month : Month, @outcome : String)
  end

  to @recipient
  from "myapp@support.com" # or set a default in src/emails/base_email.cr
  subject "your bill for #{@month}"
  templates html

  private def email_subject : String
    {%
    raise <<-MESSAGE
    Your bill for #{@month}.
    MESSAGE
    %}
  end
end
