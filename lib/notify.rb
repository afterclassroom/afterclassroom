module Notify
  include ActiveSupport
  protected
  def send_notification(user, subject, content, notify_type)
  	if notify_type == "notification_not_in_setting" 
  		send_email_and_notification(user, subject, content)
  	else
  		notification = Notification.find_by_label(notify_type)
		  if notification
		    if user.notify_email_settings.size > 0 and user.notify_email_settings.map(&:notification_id).include?(notification.id)
		      send_email_and_notification(user, subject, content)
		    end
		  end
  	end
  end

	def send_email_and_notification(user, subject, content)
		# Send email notification
		Notifi.send_notifi(user.email, subject, content).deliver
		# Send javascript notification
		begin
			Juggernaut.options = {:host => "107.20.238.0", :port => 6379}
			Juggernaut.publish("notification_#{user.id}", {:subject => subject, :content => content})
		rescue
			# Nothing
		end
	end
end
