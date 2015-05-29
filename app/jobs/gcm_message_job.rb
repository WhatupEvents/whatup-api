class GcmMessageJob
  @queue = :messages

  def self.perform(event_id, recipient_ids)
    gcm = GCM.new("AIzaSyBLDCdpQ9XBB9e-ecMI8OIQ_0pRJtd_kjg")
    response = gcm.send_notification(
      Device.where(user_id: recipient_ids).map(&:registration_id), 
      data: { event_id: event_id })
    Rails.logger.info response.to_s
  end
end
