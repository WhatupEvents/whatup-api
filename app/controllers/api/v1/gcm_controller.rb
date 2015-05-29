require 'gcm'

class Api::V1::GcmController < Api::V1::ApiController
  doorkeeper_for :all

  def message
    message = Message.create(sender_id: current_user.id, 
                             event_id: message_params["event_id"], 
                             text: Resque.redis.namespace)
#                             text: message_params["text"])
    recipient_ids = (message.event.participants - [current_user]).map(&:id)
    Resque.enqueue(GcmMessageJob, message.event_id, recipient_ids)
  end
  
  private

  def message_params
    params.require(:message).permit(:uuid, :event_id, :text)
  end
end
