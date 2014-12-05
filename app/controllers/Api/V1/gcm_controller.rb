require 'gcm'

module Api
  module V1
    class GcmController < ApiController
      doorkeeper_for :all

      def message
        #TODO: add resque to send messages asynchronously from server
        Message.create(sender_id: current_user.id, 
                       recipient_id: message_params[:friend_id], 
                       text: message_params[:text])
        
        GCM.new("AIzaSyD0Xlx-LARgUIaJKGB-VuG3TrbSoIIVjhs").send(
          Device.where(user_id: message_params[:friend_id]).map(&:registration_id), 
          data: { message_id: SecureRandom.uuid })
      end
      
      private

      def message_params
        params.require(:message).permit(:uuid, :friend_id, :text)
      end
    end
  end
end
