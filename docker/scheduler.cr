require "http/client"

def email_query
  response = HTTP::Client.get "http://#{ENV["HOST_URL"]}/api/send_email/#{ENV["SEND_TOKEN"]}"
  if response.status_code == 200
    puts "Response successful"
    puts response.body
  else
    puts "Error: #{response.status_code}"
  end
end

loop do
  begin
    email_query
  rescue e
    puts "Error: #{e.message}"
  end
  sleep 10.minutes
end
