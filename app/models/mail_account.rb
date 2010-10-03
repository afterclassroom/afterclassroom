require 'contacts'

class MailAccount
  GMAIL = 'gmail'
  YAHOOMAIL = 'yahoo'
  HOTMAIL = 'hotmail'
  AOL = 'aol'
  
  attr_accessor :login
  attr_accessor :password
  attr_accessor :mail_type
  
  def initialize(login, password, mail_type)
    @login = login
    @password = password
    @mail_type = mail_type
  end

  def contacts
    case @mail_type
      when MailAccount::GMAIL
        Contacts::Gmail.new(@login, @password).contacts
      when MailAccount::YAHOOMAIL
        Contacts::Yahoo.new(@login, @password).contacts
      when  MailAccount::HOTMAIL
        Contacts::Hotmail.new(@login, @password).contacts
      when  MailAccount::AOL
        Contacts::Aol.new(@login, @password).contacts
      else 
        []  
    end  
  end
end
