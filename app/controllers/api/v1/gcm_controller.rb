require 'gcm'

class Api::V1::GcmController < Api::V1::ApiController
  doorkeeper_for :all

  def message
    message_job = GcmMessageJob.new(message_params, current_user)
    Resque.new << message_job
  end
  
  private

  def message_params
    params.require(:message).permit(:uuid, :event_id, :text)
  end
end
