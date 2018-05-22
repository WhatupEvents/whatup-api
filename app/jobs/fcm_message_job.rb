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
            notification: {title: 'New Public Event!', body: "#{data['followed_name']} has posted a new event. ", tag: 'followed', sound: whatuppop},
            data: data,
            content_available: true,
            priority: "high"
          })
        else
          if data.has_key? 'updated_at'
            # event updated job
            resp = fcm.send_with_notification_key(reg_id, {
              notification: {title: data['event_name'], body: "has been updated", tag: "#{data['event_id']}_updt", sound: whatuppop},
              data: data,
              content_available: true,
              priority: "high"
            })
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
              notification: {title: data['event_name'], body: 'Event will be starting at '+data['start_time'].strftime("%H:%M"), tag: "#{data['event_id']}_msg", sound: whatupop},
              data: data,
              content_available: true,
              priority: "high"
            })
          else
            # event chat message job
            resp = fcm.send_with_notification_key(reg_id, {
              notification: {title: data['event_name'], body: "There's a new message, check out what your friends are up to", tag: "#{data['event_id']}_msg", sound: whatuppop},
              data: data,
              content_available: true,
              priority: "high"
            })
          end
        end
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
      Rails.logger.info resp.to_s
    end
  end
end
