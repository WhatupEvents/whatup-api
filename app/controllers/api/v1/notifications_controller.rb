class Api::V1::NotificationsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    render json: current_user.notifications,
           each_serializer: Api::V1::NotificationSerializer,
           status: :ok
  end
end
