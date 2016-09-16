class FcmMessageJob
  @queue = :messages

  def self.perform(data, recipient_id)
    #TODO: gotta move this into an environment file
    fcm = FCM.new("AIzaSyAlSPpjCGewFMOB58ExE8PmHxy7aje4D8w")
    Device.where(user_id: recipient_id).map(&:registration_id).each do |reg_id|
      resp = fcm.send_with_notification_key(reg_id, {data: data})
      Rails.logger.info resp.to_s
    end
  end
end
