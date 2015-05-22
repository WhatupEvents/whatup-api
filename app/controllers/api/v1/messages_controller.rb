class Api::V1::MessagesController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    messages = Message.where(event_id: message_params[:event_id])
    if messages.present?
      render json: messages,
             each_serializer: Api::V1::MessageSerializer,
             status: :ok
    else
      head :not_found
    end
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def message_params
    params.require(:messages).permit(:my_id, :event_id)
  end
end
