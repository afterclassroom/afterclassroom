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
      account = Contacts::Gmail.new(@login, @password)
      if account
        account.contacts
      else
        []
      end
      when MailAccount::YAHOOMAIL
      account = Contacts::Yahoo.new(@login, @password)
      if account
        account.contacts
      else
        []
      end
      when  MailAccount::HOTMAIL
      account = Contacts::Hotmail.new(@login, @password)
      if account
        account.contacts
      else
        []
      end
      when  MailAccount::AOL
      account = Contacts::Aol.new(@login, @password)
      if account
        account.contacts
      else
        []
      end
    else 
      []  
    end  
  end
end
