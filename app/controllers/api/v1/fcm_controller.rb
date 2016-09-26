require 'fcm'

class Api::V1::FcmController < Api::V1::ApiController
  doorkeeper_for :all

  def message
    sender = {sender_id: current_user.id}
    message = Message.create(sender.merge(message_params))
    recipient_ids = (message.event.participants - [current_user]).map(&:id)
    if Rails.env != "development" && current_user.id < 3
      recipient_ids.each do |recipient_id|
        Resque.enqueue(
          FcmMessageJob,{ 
            event_id: message.event_id,
            event_name: message.event.name
          },recipient_id
        )
      end
    end
  end
  
  private

  def message_params
    # params.require(:message).permit(:uuid, :event_id, :text, :media, :source, :image)
    params.permit(:event_id, :text, :media, :source, :image)
  end
end
