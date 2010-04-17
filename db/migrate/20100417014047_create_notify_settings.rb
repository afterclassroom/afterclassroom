class CreateNotifySettings < ActiveRecord::Migration
  def self.up
    create_table :notify_settings do |t|

      t.belongs_to :user

      t.belongs_to :notification

      t.boolean :sms_check

      t.boolean :email_check

      t.timestamps

    end
  end

  def self.down
    drop_table :notify_settings
  end
end
