module Notify
  include ActiveSupport
  protected
  def send_notification(user, subject, content, notify_type)
    notification = Notification.find_by_label(notify_type)
      
    if user.notify_email_settings.size > 0 and user.notify_email_settings.map(&:notification_id).include?(notification.id)
      # Send email notification
      Notifi.delay.send_notifi(rc.email, subject, content)
      # Send javascript notification
    end
  end
  
  def send_notification_to_friends(user, subject, content, notify_type)
    friends = user.user_friends
    recipients = []
    friends.each do |f|
      notification = Notification.find_by_label(notify_type)
      if notification and notification.email_allow
        recipients << f if f.notify_email_settings.size > 0 and f.notify_email_settings.map(&:notification_id).include?(notification.id)
      end
    end
    
    recipients.each do |rc|
      # Send email notification
      Notifi.delay.send_notifi(rc.email, subject, content)
      # Send javascript notification
    end
  end
end