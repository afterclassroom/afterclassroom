module Notify
  include ActiveSupport
  protected
  def send_notification(user, subject, content, notify_type)
    notification = Notification.find_by_label(notify_type)
    
    if user.notify_email_settings.size > 0 and user.notify_email_settings.map(&:notification_id).include?(notification.id)
      # Send email notification
      Notifi.send_notifi(user.email, subject, content).deliver
      # Send javascript notification
      Juggernaut.publish("notification_#{user.id}", {:subject => subject, :content => content})
    end
  end
end