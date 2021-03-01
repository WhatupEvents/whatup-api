class Api::V1::NotificationsController < Api::V1::ApiController
  before_action :doorkeeper_authorize!

  def index
    render json: current_user.notifications,
           each_serializer: Api::V1::NotificationSerializer,
           status: :ok
  end

  def destroy
    @notification = Notification.find(params[:id])

    @notification.destroy
    render json: {},
           status: :ok
  end
end
