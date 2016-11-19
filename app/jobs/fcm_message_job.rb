class FcmMessageJob
  @queue = :messages

  def self.perform(data, recipient_id)
    #TODO: gotta move this into an environment file
    fcm = FCM.new("AIzaSyAlSPpjCGewFMOB58ExE8PmHxy7aje4D8w")
    fcm = FCM.new("AAAAbeSD7bc:APA91bH5ilSjjNzDQOhIZoIJJFWxVTImMXf8ILD_MtUmqWPHOUoNdwmeUH5lEFC4mPv5phtWI3ucXe49AaFC8slJzLqseV7ZYrQ7GrlbTy9eHEpAAN_-YsH_3SNuSjHF_0G5CxLDt-LN0RgloT_igSj9N2diVKgSVw")
    Device.where(user_id: recipient_id).map(&:registration_id).uniq.each do |reg_id|
      if data.has_key? 'event_name'
        if data.has_key? 'updated_at'
          resp = fcm.send_with_notification_key(reg_id, {
            notification: {title: data['event_name'], body: "has been updated", tag: "#{data['event_id']}_updt"},
            data: {event_id: data['event_id']},
            content_available: true,
            priority: "high"
          })
        else
          resp = fcm.send_with_notification_key(reg_id, {
            notification: {title: data['event_name'], body: "#{data['event_name']} message", tag: "#{data['event_id']}_msg"},
            data: {event_id: data['event_id']},
            content_available: true,
            priority: "high"
          })
        end
      else
        resp = fcm.send_with_notification_key(reg_id, {
          notification: {title: 'Set a status!', body: "you haven't updated in a while", tag: 'status'},
          data: {},
          content_available: true,
          priority: "high"
        })
      end
      Rails.logger.info resp.to_s
    end
  end
end
