class QaSendMail < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.qa_send_mail.refer_to_expert.subject
  #
  def refer_to_expert(qapost, content, receiver_email)
    @greeting = "HELLO FROM REFER TO EXPERT"

    mail :to => receiver_email, :subject => "Plese response"
    
  end
end
