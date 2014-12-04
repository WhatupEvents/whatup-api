module Api
  module V1
    class MessagesController < ApiController
      doorkeeper_for :all

      def index
        head :ok
      end

      def message_params
        params.permit(:sender_id, :recipient_id)
      end
    end
  end
end
