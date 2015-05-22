class GcmMessageJob
  @queue = :messages

  def initialize(message_params, sender)
    @message_params = message_params
    @sender = sender
  end

  def self.perform
    message = Message.create(sender_id: @sender.id, 
                             event_id: @message_params[:event_id], 
                             text: @message_params[:text])

    recipient_ids = (message.event.participants - [@sender]).map(&:id)
    GCM.new("AIzaSyBLDCdpQ9XBB9e-ecMI8OIQ_0pRJtd_kjg").send(
      Device.where(user_id: recipient_ids).map(&:registration_id), 
      data: { event_id: message.event_id })
  end
end
