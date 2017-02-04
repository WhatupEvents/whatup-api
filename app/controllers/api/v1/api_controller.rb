class Api::V1::ApiController < ActionController::API
  include ActionController::Serialization

  before_action :geo_update

  def geo_update
    if request.env["HTTP_GEOLOCATION"].present? && 
      request.env["HTTP_AUTHORIZATION"] != 'Bearer null'
      @geo = request.env["HTTP_GEOLOCATION"]
      Rails.logger.info @geo
      # current_user.update_attributes(
      #   longitude: geo.split(':')[0],
      #   latitude: geo.split(':')[1]
      # )
    end
  end

  def get_geo
    Rails.logger.info @geo
    @geo
  end

  def process_access_token
    token_attributes = {
      application: current_application,
      resource_owner_id: current_user.id,
      revoked_at: nil,
      expires_in: Doorkeeper.configuration.access_token_expires_in
    }
    token = Doorkeeper::AccessToken.find_or_create_by(token_attributes)
    if token.expired?
      current_user.doorkeeper_access_tokens.destroy_all
      token = Doorkeeper::AccessToken.create(token_attributes)
    end
    return token
  end

  def current_application
    @current_application ||= begin
      doorkeeper_token.try(:application) ||
      Doorkeeper::Application.find_by_uid!(params[:app_id])
    end
  end

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id)
  end

  def doorkeeper_unauthorized_render_options
    {json: '{"status": "failure", "message":"401 Unauthorized"}'}
  end
end
