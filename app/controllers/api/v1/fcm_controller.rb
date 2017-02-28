require 'fcm'

class Api::V1::FcmController < Api::V1::ApiController
  doorkeeper_for :all

  def message
    sender = {sender_id: current_user.id}
    message = Message.create(sender.merge(message_params))
    if Rails.env != "development"
      message.event.participant_relationships.each do |participant|
        if participant.notify && (participant.participant_id != current_user.id)
          Resque.enqueue(
            FcmMessageJob,{ 
              event_id: message.event_id,
              event_name: message.event.name
            },participant.participant_id
          )
        end
      end
    end
    render json: {}, status: :not_found
  end
  
  private

  def message_params
    # params.require(:message).permit(:uuid, :event_id, :text, :media, :source, :image)
    params.permit(:event_id, :text, :media, :source, :image)
  end
end
