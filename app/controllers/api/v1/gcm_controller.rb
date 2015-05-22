require 'gcm'

class Api::V1::GcmController < Api::V1::ApiController
  doorkeeper_for :all

  def message
    Resque.enqueue(GcmMessageJob, message_params, current_user.id)
  end
  
  private

  def message_params
    params.require(:message).permit(:uuid, :event_id, :text)
  end
end
