class FcmMessageJob
  @queue = :messages

  def self.perform(data, recipient_ids)
    #TODO: gotta move this into an environment file

    fcm = FCM.new("AIzaSyAlSPpjCGewFMOB58ExE8PmHxy7aje4D8w")
    # resp = fcm.send(
    #   Device.where(user_id: recipient_ids).map(&:registration_id),
    #   {data: data})
    # Rails.logger.info resp.to_s

    # resp = fcm.send_with_notification_key(
    #   Device.where(user_id: recipient_ids).map(&:registration_id),
    #   {data: data})
    # Rails.logger.info resp.to_s

    Device.where(user_id: recipient_ids).map(&:registration_id).each do |reg_id|
      resp = fcm.send_with_notification_key(reg_id, {data: data})
      Rails.logger.info resp.to_s
    end

    # fcm = FCM.new("AIzaSyDkhn2fkoHTzghKXo-Jhkkofoq5Q_kRYtQ")
    # resp = fcm.send(
    #   Device.where(user_id: recipient_ids, os: "iOS").map(&:registration_id), 
    #   data)
    # Rails.logger.info resp.to_s

    # fcm = FCM.new("AIzaSyDrZ95JxylkKXiV7MZIvp5KyEnFOQW04is")
    # resp = fcm.send(
    #   Device.where(user_id: recipient_ids, os: "Android").map(&:registration_id), 
    #   data)
    # Rails.logger.info resp.to_s
  end
end
