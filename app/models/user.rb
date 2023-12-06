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

  private

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
    SendFreeWhatsappJob.perform_now(phone, WhatsappMessages.message(:REGISTRATION, :SHOW_WINDIE_FEATURES))
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
