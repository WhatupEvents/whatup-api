require 'gcm'

class Api::V1::GcmController < Api::V1::ApiController
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
