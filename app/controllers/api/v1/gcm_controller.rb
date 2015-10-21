require 'gcm'

class Api::V1::GcmController < Api::V1::ApiController
  doorkeeper_for :all

  def message
    sender = {sender_id: current_user.id}
    message = Message.create(sender.merge(message_params))
    recipient_ids = (message.event.participants - [current_user]).map(&:id)
    if Rails.env != "development"
      Resque.enqueue(
        GcmMessageJob,
        { 
          event_id: message.event_id,
          event_name: message.event.name },
        recipient_ids
      )
    end
  end
  
  private

  def message_params
    # params.require(:message).permit(:uuid, :event_id, :text, :media, :source, :image)
    params.permit(:event_id, :text, :media, :source, :image)
  end
end
