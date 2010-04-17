class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|

      t.boolean :sms_allow

      t.boolean :email_allow

      t.string :name

      t.string :label

      t.string :notify_type


      t.timestamps

    end
  end

  def self.down
    drop_table :notifications
  end
end
