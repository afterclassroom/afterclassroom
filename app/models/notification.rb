class Notification < ActiveRecord::Base
  has_many :notify_settings
  has_many :notify_emails
end
