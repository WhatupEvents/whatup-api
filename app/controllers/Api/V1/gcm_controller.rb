require 'gcm'

module Api
  module V1
    class GcmController < ApiController
      doorkeeper_for :all

      def message
        #TODO: add resque to send messages asynchronously from server
        device = Device.find_by_uuid(message_params[:uuid])
        gcm = GCM.new("AIzaSyD0Xlx-LARgUIaJKGB-VuG3TrbSoIIVjhs")
        gcm_response = gcm.send([device.registration_id], data: { message_id: SecureRandom.uuid })
      end
      
      private

      def message_params
        params.require(:message).permit(:uuid)
      end
    end
  end
end
