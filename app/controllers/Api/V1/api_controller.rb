module Api
  module V1
    class ApiController < ActionController::API
      include ActionController::Serialization

      def process_access_token
        token_attributes = {
          application: current_application,
          resource_owner_id: current_user.id,
          revoked_at: nil,
          expires_in: Doorkeeper.configuration.access_token_expires_in
        }
        Doorkeeper::AccessToken.find_or_create_by(token_attributes)
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
    end
  end
end
