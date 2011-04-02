class Notification < ActiveRecord::Base
  # Relations
  has_many :notify_sms_settings, :dependent => :destroy
  has_many :notify_email_settings, :dependent => :destroy
  # Named Scope
  scope :with_type, lambda { |tp| {:conditions => ["notify_type = ?", tp]} }
end
