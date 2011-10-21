class SignupNotificationJob < Struct.new(:email, :subject, :content)
  def perform
    SignupNotification.send_notification_for_same_school(email, subject, content)
  end
end
