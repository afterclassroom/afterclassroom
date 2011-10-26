# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "https://#{Setting.get(:site_url)}/activate/#{user.activation_code}"
		@sent_on = Time.now
    @headers = {}
    @content_type = 'text/html'
  end
  
  def reset_password(user)
    setup_email(user)
    @subject += "Your password has been reset"
    @body[:url]  = "https://login.#{Setting.get(:site_url)}/login"
		@sent_on = Time.now
    @headers = {}
    @content_type = 'text/html'
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject += "Forgotten password instructions"
    @body[:url]  = "https://#{Setting.get(:site_url)}/users/reset_password/#{user.password_reset_code}"
		@sent_on = Time.now
    @headers = {}
    @content_type = 'text/html'
  end
  
  def forgot_login(user)
    setup_email(user)
    @subject += "Forgotten account login"
    @body[:url]  = "https://login.#{Setting.get(:site_url)}/login"
		@sent_on = Time.now
    @headers = {}
    @content_type = 'text/html'
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "https://#{Setting.get(:site_url)}/"
		@sent_on = Time.now
    @headers = {}
    @content_type = 'text/html'
  end

  def invitation(user, email, domain, invitation_code, content)
      logger.info("invitation_email:" + invitation_code.to_s)
      @subject = user.name + ' has invited you to join Afterclassroom'
      @body = {:user => user,
              :invitation_url => signup_url(:protocol => 'https', :host=> domain)+ '?invitation_code=' + invitation_code.to_s,
              :content => content
              }
      @recipients = email
      @from = "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
      @sent_on = Time.now
      @headers = {}
      @content_type = 'text/html'
    end
    
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
      @subject     = "[#{Setting.get(:site_name)}] "
      @body[:user] = user
      
      # Get Settings
      [:site_name, :company_name, :support_email, :support_name].each do |id|
        @body[id] = Setting.get(id)
      end
			@sent_on = Time.now
      @headers = {}
      @content_type = 'text/html'
    end
end
