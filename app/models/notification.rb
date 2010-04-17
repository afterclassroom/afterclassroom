class Notification < ActiveRecord::Base
  has_many :notify_settings
end
