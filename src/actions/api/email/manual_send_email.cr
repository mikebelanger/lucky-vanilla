class Api::ManualSend < BrowserAction
  get "/api/email/manual_send/:split_id" do
    split = SplitQuery.new.find(split_id)
    if split
      sent = split.send_bill_splits(only_send_every_n_hours: 0)

      if sent
        json({message: "split: #{split_id} manually sent"})
      else
        json({message: "split #{split_id} **not** sent"})
      end
    end
    json({message: "split not found"})
  end
end
