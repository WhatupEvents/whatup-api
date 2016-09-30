class FcmMessageJob
  @queue = :messages

  def self.perform(data, recipient_id)
    #TODO: gotta move this into an environment file
    fcm = FCM.new("AIzaSyAlSPpjCGewFMOB58ExE8PmHxy7aje4D8w")
    Device.where(user_id: recipient_id).map(&:registration_id).uniq.each do |reg_id|
      # , tag: "#{data['event_id']}"
      resp = fcm.send_with_notification_key(reg_id, {
        notification: {title: data['event_name'], body: "#{data['event_name']} message"},
        data: {event_id: data['event_id']},
        content_available: true,
        priority: "high"
      })
      Rails.logger.info resp.to_s
    end
  end
end
