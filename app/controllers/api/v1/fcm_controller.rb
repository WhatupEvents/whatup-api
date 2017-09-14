require 'fcm'

class Api::V1::FcmController < Api::V1::ApiController
  doorkeeper_for :all

  def message
    sender = {sender_id: current_user.id}
    message = Message.create(sender.merge(message_params))
    if Rails.env != "development"
      message.event.participant_relationships.each do |participant|
        # increases unread count
        participant.update_attributes(unread: participant.unread.nil? ? 1 : participant.unread+1)

        if participant.notify && (participant.participant_id != current_user.id) && participant.unread == 1
          Resque.enqueue(
            FcmMessageJob,{ 
              event_id: message.event_id,
              event_name: message.event.name
            },participant.participant_id
          )
        end
      end
    end
    # render json: {}, status: :not_found
    head :ok
  end

  def messages_read
    participant = ParticipantRelationship.where(event_id: message_params[:event_id], participant_id: current_user.id).last
    participant.update_attributes(unread: 0)
  end
  
  private

  def message_params
    # params.require(:message).permit(:uuid, :event_id, :text, :media, :source, :image)
    params.permit(:event_id, :text, :media, :source, :image)
  end
end
