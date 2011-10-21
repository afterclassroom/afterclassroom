class SignupNotification < ActionMailer::Base
  def send_notification_for_same_school(recipient, subject, content)
    @content = content

    mail(:to => recipient, :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>", :subject => subject).deliver
    
  end
end
