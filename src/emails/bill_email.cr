class BillEmail < BaseEmail
  # Read more on emails
  # https://luckyframework.org/guides/emails/sending-emails-with-carbon
  #
  # Send this email with:
  # ```
  # to = UserQuery.first
  # BillEmail.new(to).deliver
  # ```
  def initialize(@to : Carbon::Emailable, @split : Split)
  end

  to @to
  from "bill@vanillasplit.com" # or set a default in src/emails/base_email.cr
  subject "your bill for #{@split.month_and_year}"
  templates bill_email

  def html_body
    <<-HTML
      <h1>Hello, #{@to.carbon_address}</h1>
      <p>This is your bill for #{@split.month_and_year}.</p>
      <p>Outcome: #{@split.outcome}.</p>
      <p>Total: #{@split.total_amount}.</p>
    HTML
  end

  def template_id
    ENV["BILL_TEMPLATE_ID"]
  end

  def variables
    {
      "var": "Vanilla Split",
      "outcome": @split.outcome
    }
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
