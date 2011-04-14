class Notifi < ActionMailer::Base
  default :from => "technical@afterclassroom.com"
  
  def send_notifi(recipient, subject, content)
    @content = content

    mail :to => recipient, :subject => subject
    
  end
end