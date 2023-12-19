class User < ApplicationRecord
  include AASM
  include PowerTypes::Observable

  has_many :user_spots, dependent: :destroy
  has_many :user_sports, dependent: :destroy
  has_many :spots, through: :user_spots
  has_many :sports, through: :user_sports

  validates :phone, uniqueness: { message: 'must be unique' }
  validates :alias, format: { without: /\s/, message: 'must contain no spaces' }

  aasm column: :registration_state do
    state :unregistered, initial: true
    state :waiting_for_alias, before_enter: :ask_alias_message
    state :waiting_for_sports, before_enter: :ask_sports_message
    state :waiting_for_spots, before_enter: :ask_spots_message, before_exit: :show_features
    state :registered

    event :ask_alias do
      transitions from: :unregistered, to: :waiting_for_alias
    end

    event :ask_sports do
      transitions from: :waiting_for_alias, to: :waiting_for_sports
    end

    event :ask_spots do
      transitions from: :waiting_for_sports, to: :waiting_for_spots
    end

    event :register do
      transitions from: :waiting_for_spots, to: :registered
    end
  end

  def user_alias
    self.alias
  end

  def send_today_report
    message = build_daily_report_message(user_spot.today_report_summary, "hoy")
    SendFreeWhatsappJob.perform_now(phone, message)
  end

  def send_tomorrow_report
    message = build_daily_report_message(user_spot.tomorrow_report_summary, "mañana")
    SendFreeWhatsappJob.perform_now(phone, message)
  end

  def send_next_week_report
    message = build_weekly_report_message(user_spot.next_week_report_summary)
    SendFreeWhatsappJob.perform_now(phone, message)
  end

  def send_today_tides
    message = build_tides_message(user_spot.today_tides)
    SendFreeWhatsappJob.perform_now(phone, message)
  end

  def send_tomorrow_tides
    message = build_tides_message(user_spot.tomorrow_tides)
    SendFreeWhatsappJob.perform_now(phone, message)
  end

  def send_big_wave_report
    message = build_big_wave_report_message(user_spot.big_wave_alert)
    SendFreeWhatsappJob.perform_now(phone, message)
  end

  def send_error_message
    SendFreeWhatsappJob.perform_now(phone, WhatsappMessages.message(:CONVERSATION, :ERROR))
  end

  def user_spot
    @user_spot ||= spots.first
  end

  private

  def build_daily_report_message(report, day)
    "Este es el reporte de #{day} para *#{user_spot.name}*:\n\n
    En la *mañana* habrán olas de *#{report["morning"]["wave"]} metros*, viento de *#{report["morning"]["wind"]} nudos* con dirección *#{report["morning"]["wind_direction"]}* y periodo de *#{report["morning"]["period"]} segundos*.\n
    En la *tarde* habrán olas de *#{report["afternoon"]["wave"]} metros*, viento de *#{report["afternoon"]["wind"]} nudos* con dirección #{report["afternoon"]["wind_direction"]} y periodo de *#{report["afternoon"]["period"]} segundos*.\n
    Las *mareas bajas* serán a las #{report["tides"]["Lo"][0]} y #{report["tides"]["Lo"][1]}, y las *mareas altas* a las #{report["tides"]["Hi"][0]} y #{report["tides"]["Hi"][1]}.\n\n
    Buenas olas #{user_alias}! 🤙🏼"
  end

  def build_weekly_report_message(weekly_report)
    message = "Este es el reporte de la próxima semana en *#{user_spot.name}*:\n\n"
    days = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]
    weekly_report.each_with_index do |(date, report), index|
      message += "#{days[index]} (#{date}):\n
      En la *mañana* habrán olas de #{report["morning"]["wave"]}, viento de #{report["morning"]["wind"]} nudos con dirección #{report["morning"]["wind_direction"]} y periodo de *#{report["morning"]["period"]} segundos*.\n
      En la *tarde* habrán olas de #{report["afternoon"]["wave"]}, viento de #{report["afternoon"]["wind"]} nudos con dirección #{report["afternoon"]["wind_direction"]} y periodo de *#{report["afternoon"]["period"]} segundos*.\n
      Las *mareas bajas* serán a las #{report["tides"]["Lo"].join(' y ')}, y las *mareas altas* a las #{report["tides"]["Hi"].join(' y ')}."
    end
    message
  end

  def build_tides_message(tides)
    "Las mareas para hoy en *#{user_spot.name}* son:\n\n
    Las *mareas bajas* serán a las *#{tides["Lo"].join(' y ')}*, y las *mareas altas* a las *#{tides["Hi"].join(' y ')}*."
  end

  def build_big_wave_report_message(big_wave_report)
    return "No hay olas grandes dentro de la próxima semana 🙁" if big_wave_report === "No big waves in the next week"

    message = "🌊🌊🌊 Habrán olas grandes dentro de la próxima semana en #{user_spot.name}:\n\n"
    big_wave_report.each do |date, report|
      message += "#{date}:\n
      En la *mañana* habrán olas de *#{report["morning"]["wave"]} metros*, viento de *#{report["morning"]["wind"]} nudos* con dirección *#{report["morning"]["wind_direction"]}* y periodo de *#{report["morning"]["period"]} segundos*.\n
      En la *tarde* habrán olas de *#{report["afternoon"]["wave"]} metros*, viento de *#{report["afternoon"]["wind"]} nudos* con dirección *#{report["afternoon"]["wind_direction"]}* y periodo de *#{report["afternoon"]["period"]} segundos*.\n
      Las *mareas bajas* serán a las #{report["tides"]["Lo"].join(' y ')}, y las *mareas altas* a las #{report["tides"]["Hi"].join(' y ')}.\n\n
      Buenos olones #{user_alias}! 🤙🏼"
    end
    message
  end


  def ask_alias_message
    SendFreeWhatsappJob.perform_now(phone, WhatsappMessages.message(:REGISTRATION, :ASK_ALIAS))
  end

  def ask_sports_message
    SendWhatsappTemplateJob.perform_now(phone, TwilioConstants.ask_sports_template_sid, get_whatsapp_variables_for_asking_sport(self.user_alias))
  end

  def ask_spots_message
    SendWhatsappTemplateJob.perform_now(phone, TwilioConstants.ask_spots_template_sid, {})
  end

  def show_features
    SendFreeWhatsappJob.perform_now(phone, WhatsappMessages.message(:REGISTRATION, :SHOW_WINDIE_FEATURES_BETA))
  end

  def get_whatsapp_variables_for_asking_sport(user_alias)
    {
      '1' => user_alias
    }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  alias                  :string
#  phone                  :string
#  registration_state     :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
