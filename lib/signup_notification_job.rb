class SignupNotificationJob < Struct.new(:new_user, :users)
  def perform
    users.each do |u|
			subject = "Do you know #{new_user.name}?"
			content = "Dear #{u.name},"
			content << "You might know #{new_user.name} who just joined After Classroom from #{new_user.school.name}."
			content << "Click #{link_to("here", show_lounge_users_url(new_user))} to check who is #{new_user.name}."
			SignupNotification.send_notification_for_same_school(u.email, subject, content)
		end
  end
end
