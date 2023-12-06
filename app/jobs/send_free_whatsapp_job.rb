require 'twilio-ruby'

class SendFreeWhatsappJob < ApplicationJob
  queue_as :default

  def perform(phone, message)
    @client = Twilio::REST::Client.new(TwilioConstants.account_sid, TwilioConstants.auth_token)
    message = @client.messages.create(
      body: message,
      from: "whatsapp:#{TwilioConstants.sandbox_phone_number}",
      to: "whatsapp:#{phone}"
    )
    message.sid
  rescue Twilio::REST::RestError => e
    e.message
    false
  end
end
