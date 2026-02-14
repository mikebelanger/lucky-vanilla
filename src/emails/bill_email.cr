class BillEmail < BaseEmail
  # Read more on emails
  # https://luckyframework.org/guides/emails/sending-emails-with-carbon
  #
  # Send this email with:
  # ```
  # recipient = UserQuery.first
  # BillEmail.new(recipient).deliver
  # ```
  Habitat.create { setting stubbed_token : String? }
  delegate stubbed_token, to: :settings

  def initialize(@recipient : Carbon::Emailable, @split : Split)

  end

  to @recipient
  from "bill@vanillasplit.com" # or set a default in src/emails/base_email.cr
  subject "your bill for #{@split.start_day} to #{@split.end_day}"
  templates html

  def template_id
    ENV["BILL_TEMPLATE_ID"]
  end

  private def email_subject : String
    {%
      raise <<-MESSAGE
    Your bill for #{@month}.
    MESSAGE
    %}
  end

  after_send do |email|
    SaveSplit.update!(@split, bill_sent_amount: @split.bill_sent_amount + 1)
  end
end
