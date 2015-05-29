class GcmMessageJob
  @queue = :messages

  def self.perform(event_id, recipient_ids)
    GCM.new("AIzaSyBLDCdpQ9XBB9e-ecMI8OIQ_0pRJtd_kjg").send(
      Device.where(user_id: recipient_ids).map(&:registration_id), 
      data: { event_id: event_id })
  end
end
