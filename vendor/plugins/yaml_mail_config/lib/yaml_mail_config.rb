# If the Rails.env is not +test+, open up <tt>Rails.root/config/email.yml</tt>
# and set ActionMailer::Base's SMTP settings using that.
if Rails.env != 'test'
  c = YAML::load(File.open("#{Rails.root}/config/email.yml"))
    
  ActionMailer::Base.smtp_settings = {
    :address => c[Rails.env]['server'],
    :port => c[Rails.env]['port'],
    :domain => c[Rails.env]['domain'],
    :authentication => c[Rails.env]['authentication'],
    :user_name => c[Rails.env]['username'],
    :password => c[Rails.env]['password'],
    :tls => c[Rails.env]['tls'] == "true"
  }
end