require 'twilio-ruby'

class SendWhatsappTemplateJob < ApplicationJob
  queue_as :default

  def perform(phone, content_sid, content_variables)
    @client = Twilio::REST::Client.new(TwilioConstants.account_sid, TwilioConstants.auth_token)
    message = @client.messages.create(
      content_sid: content_sid,
      from: "whatsapp:#{TwilioConstants.phone_number}",
      content_variables: content_variables.to_json,
      messaging_service_sid: TwilioConstants.messaging_service_sid,
      to: "whatsapp:#{phone}"
    )
    message.sid
  rescue Twilio::REST::RestError => e
    e.message
    false
  end
end
