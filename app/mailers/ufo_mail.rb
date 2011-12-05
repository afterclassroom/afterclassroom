class UfoMail < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
  default_url_options[:host] = "afterclassroom.com"
  
  def inviteinform(friend,ufo_author,ufo)
    @friend = friend
    @ufo_author = ufo_author
    @ufo = ufo
    #mail :to => friend.email, :subject => "#{ufo_author.name} invite you to join a topic."
    mail :to => "datefield@yahoo.com", :subject => "#{ufo_author.name} invite you to join a topic."
  end
  
end