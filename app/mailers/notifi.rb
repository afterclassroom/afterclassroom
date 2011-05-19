class Notifi < ActionMailer::Base
  default :from => "technical@afterclassroom.com"
  default_url_options[:host] = "afterclassroom.com"
  
  def send_notifi(recipient, subject, content)
    @content = content

    mail :to => recipient, :subject => subject
    
  end
  handle_asynchronously :send_notifi
end