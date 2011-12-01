class UfoMail < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
  default_url_options[:host] = "afterclassroom.com"
  
  def testufo
    mail :to => "datefield@yahoo.com", :subject => "test send mail"
  end
  
end
