require 'gcm'

class Api::V1::GcmController < Api::V1::ApiController
  doorkeeper_for :all

  def message
    sender = {sender_id: current_user.id}
    message = Message.create(sender.merge(message_params))
    recipient_ids = (message.event.participants - [current_user]).map(&:id)
    Resque.enqueue(GcmMessageJob, message.event_id, recipient_ids)
  end
  
  private

  def message_params
    # params.require(:message).permit(:uuid, :event_id, :text, :media, :source, :image)
    params.permit(:uuid, :event_id, :text, :media, :source, :image)
  end
end
