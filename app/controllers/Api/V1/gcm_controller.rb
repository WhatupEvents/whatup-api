require 'gcm'

module Api
  module V1
    class GcmController < ApiController
      doorkeeper_for :all

      def message
        #TODO: add resque to send messages asynchronously from server
        message = Message.create(sender_id: current_user.id, 
                                 event_id: message_params[:event_id], 
                                 text: message_params[:text])

        recipient_ids = (message.event.participants - [current_user]).map(&:id)
        GCM.new("AIzaSyD0Xlx-LARgUIaJKGB-VuG3TrbSoIIVjhs").send(
          Device.where(user_id: recipient_ids).map(&:registration_id), 
          data: { message_id: SecureRandom.uuid })
      end
      
      private

      def message_params
        params.require(:message).permit(:uuid, :event_id, :text)
      end
    end
  end
end
