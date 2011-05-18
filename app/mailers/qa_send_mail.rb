class QaSendMail < ActionMailer::Base
  default :from => "technical@afterclassroom.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.qa_send_mail.refer_to_expert.subject
  #
  def refer_to_expert(introduce, receiver_email, post_id)
    
    @post = Post.find(post_id)
    @introduce = introduce

    mail :to => receiver_email, :subject => "Please response. Thank you for your support !"
    
  end
end
