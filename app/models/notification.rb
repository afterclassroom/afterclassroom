class Notification < ActiveRecord::Base
  # Relations
  has_many :notify_sms_settings
  has_many :notify_email_settings
  # Named Scope
  scope :with_type, lambda { |tp| {:conditions => ["notify_type = ?", tp]} }
end
