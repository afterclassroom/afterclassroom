class CreateNotifySmsSettings < ActiveRecord::Migration
  def self.up
    create_table :notify_sms_settings do |t|
      t.belongs_to :user
      t.belongs_to :notification
    end
  end

  def self.down
    drop_table :notify_sms_settings
  end
end
