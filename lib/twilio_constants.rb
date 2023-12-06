module TwilioConstants

  def self.whatsapp_button_text(type)
    WHATSAPP_BUTTONS[type]
  end

  def self.account_sid
    @account_sid ||= ENV.fetch('TWILIO_ACCOUNT_SID')
  end

  def self.auth_token
    @auth_token ||= ENV.fetch('TWILIO_AUTH_TOKEN')
  end

  def self.phone_number
    @phone_number ||= ENV.fetch('TWILIO_PHONE_NUMBER')
  end

  def self.sandbox_phone_number
    @sandbox_phone_number ||= ENV.fetch('TWILIO_SANDBOX_PHONE_NUMBER')
  end

  def self.messaging_service_sid
    @messaging_service_sid ||= ENV.fetch('TWILIO_MESSAGING_SERVICE_SID')
  end

  def self.ask_sports_template_sid
    @ask_sports_template_sid ||= ENV.fetch('TWILIO_ASK_SPORTS_TEMPLATE_SID')
  end

  def self.ask_spots_template_sid
    @ask_spots_template_sid ||= ENV.fetch('TWILIO_ASK_SPOTS_TEMPLATE_SID')
  end
end
