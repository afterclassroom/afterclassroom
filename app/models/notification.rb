class Notification < ActiveRecord::Base
  has_many :notify_sms_settings
  has_many :notify_emails
end
