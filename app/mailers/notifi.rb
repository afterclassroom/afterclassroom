class Notifi < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
  default_url_options[:host] = "afterclassroom.com"
  
  def send_notifi(recipient, subject, content)
    @content = content

    mail :to => recipient, :subject => subject
    
  end
end
