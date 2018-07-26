require 'json'

class FcmMessageJob
  @queue = :messages

  def self.perform(data)
    fcm = FCM.new(ENV['FCM_LEGACY_SERVER_KEY'])
    fcm = FCM.new(ENV['FCM_SERVER_KEY'])

    device = Device.where(user_id: data['recipient_id'])
    device.map{|d| [d.registration_id, d.os]}.uniq.each do |reg_id, os|
      whatuppop = 'whatuppop'
      if os == 'iOS'
        whatuppop += '.wav'
      end

      if data.has_key? 'event_name'
        ##### EVENTS JOBS #####
        if data.has_key? 'followed_name'
          # followed creator new event job
          resp = fcm.send_with_notification_key(reg_id, {
            notification: {title: 'New Public Event!', body: "#{data['followed_name']} has posted a new event: #{data['event_name']}", tag: 'followed', sound: whatuppop},
            data: data,
            content_available: true,
            priority: "high"
          })
          Notification.create(text: data['followed_name']+" has posted a new event: #{data['event_name']}", data: data.to_json, user_id: data['recipient_id'])
        else
          if data.has_key? 'updated_at'
            # event updated job
            resp = fcm.send_with_notification_key(reg_id, {
              notification: {title: data['event_name'], body: "has been updated", tag: "#{data['event_id']}_updt", sound: whatuppop},
              data: data,
              content_available: true,
              priority: "high"
            })
            Notification.create(text: data['event_name']+" has been updated", data: data.to_json, user_id: data['recipient_id'])
          elsif data.has_key? 'deleted_at'
            # event deleted job
            resp = fcm.send_with_notification_key(reg_id, {
              data: data,
              content_available: true,
              priority: "high"
            })
          elsif data.has_key? 'start_time'
            # event starts soon job
            resp = fcm.send_with_notification_key(reg_id, {
              notification: {title: data['event_name'], body: "will be starting in #{data['diff']} minutes", tag: "#{data['event_id']}_msg", sound: whatuppop},
              data: data,
              content_available: true,
              priority: "high"
            })
            Notification.create(text: "#{data['event_name']} will be starting in #{data['diff']} minutes", data: data.to_json, user_id: data['recipient_id'])
          else
            # event chat message job
            resp = fcm.send_with_notification_key(reg_id, {
              notification: {title: data['event_name'], body: "There's a new message, check out what your friends are up to", tag: "#{data['event_id']}_msg", sound: whatuppop},
              data: data,
              content_available: true,
              priority: "high"
            })
            Notification.create(text: "#{data['event_name']} has a new message, check out what your friends are up to", data: data.to_json, user_id: data['recipient_id'])
          end
        end
      else
        if !data.has_key? 'shout_id'
          ##### SHOUT JOBS #####
          resp = fcm.send_with_notification_key(reg_id, {
            data: data,
            content_available: true,
            priority: "high"
          })
        else
          ##### STATUS JOBS #####
          if data.has_key? 'status_id'
            # friend status update job
            resp = fcm.send_with_notification_key(reg_id, {
              data: data,
              content_available: true,
              priority: "high"
            })
          elsif data.has_key? 'ups'
            # upped status for user job
            resp = fcm.send_with_notification_key(reg_id, {
              data: data,
              content_available: true,
              priority: "high"
            })   
          elsif data.has_key? 'status_text'
            # interested friend in status job
            resp = fcm.send_with_notification_key(reg_id, {
              notification: {title: 'Status was pinged!', body: "#{data['friend_name']} is interested in: '#{data['status_text']}'"},
              data: data,
              content_available: true,
              priority: "high"
            })
            text = "#{data['friend_name']} is interested in status: '#{data['status_text']}'"
            uid = data['recipient_id']
            json = data.to_json

            Rails.logger.info text
            Rails.logger.info uid
            Rails.logger.info json

            Notification.create(text: text, data: json, user_id: uid)
          else
              # set a status job
              resp = fcm.send_with_notification_key(reg_id, {
                notification: {title: 'Set a status!', body: "you haven't updated in a while", tag: 'status'},
                data: data,
                content_available: true,
                priority: "high"
              })
          end
        end
      end
      Rails.logger.info resp.to_s
    end
  end
end
