module Api
  module V1
    class MessagesController < ApiController
      doorkeeper_for :all

      def index
        messages = Message.where(sender_id: [message_params[:my_id], message_params[:friend_id]],
                                 recipient_id: [message_params[:my_id], message_params[:friend_id]])
        if messages.present?
          render json: messages,
                 each_serializer: Api::V1::MessageSerializer,
                 status: :ok
        else
          head :not_found
        end
      rescue Exception => e
        head :bad_request
      end

      def message_params
        params.permit(:my_id, :friend_id)
      end
    end
  end
end
