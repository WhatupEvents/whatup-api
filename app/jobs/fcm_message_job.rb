class FcmMessageJob
  @queue = :messages

  def self.perform(data, recipient_ids)
    fcm = FCM.new("AIzaSyAlSPpjCGewFMOB58ExE8PmHxy7aje4D8w")
    response = fcm.send(
      Device.where(user_id: recipient_ids).map(&:registration_id), 
      data)
    Rails.logger.info response.to_s
  end
end
