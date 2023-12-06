class Api::V1::Webhook::ChatController < Api::V1::Webhook::BaseController
  skip_before_action :verify_authenticity_token

  def handle_user_chat
    return create_user if new_user?

    case user.registration_state
    when 'waiting_for_alias'
      handle_alias_response
    when 'waiting_for_sports'
      handle_sports_response
    when 'waiting_for_spots'
      handle_spots_response
    when 'registered'
      handle_any_response
    end
  end

  private

  def new_user?
    !User.exists?(phone: origin_phone)
  end

  def create_user
    user = User.create!(phone: origin_phone)
    user.ask_alias!
    respond_with user, status: :created
  rescue ActiveRecord::RecordInvalid => e
    respond_with e.record, status: :unprocessable_entity
  end

  def user
    @user ||= User.find_by(phone: origin_phone)
  end

  def origin_phone
    @origin_phone ||= "+#{params[:WaId]}"
  end

  def handle_alias_response
    user.update(alias: params[:Body].downcase)
    user.ask_sports!
    respond_with user, status: :ok
  end

  def handle_sports_response
    sport = Sport.find_by(sport_name: params[:Body].downcase)
    user.sports << sport
    user.ask_spots!
    respond_with user, status: :ok
  end

  def handle_spots_response
    spot = Spot.find_by(windguru_code: params[:Body].downcase)
    user.spots << spot
    user.register!
    respond_with user, status: :ok
  end

  def handle_any_response
    respond_with user, status: :ok
  end
end
