class UfoMail < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
  default_url_options[:host] = "afterclassroom.com"
  
  def testufo
    mail :to => "datefield@yahoo.com", :subject => "test send mail"
  end
  
  def inviteinform(arr_bcc,ufo_author)
    test = []
    test << "datefield@yahoo.com"
    test << "ngothiendat@gmail.com"
    @listbcc = arr_bcc
    mail :to => ["datefield@yahoo.com","ngothiendat@gmail.com"], :subject => "#{ufo_author.name} invite you to join a topic."
    
  end
  
end
