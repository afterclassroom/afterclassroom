class CreatePrivateSettings < ActiveRecord::Migration
  def self.up
    create_table :private_settings do |t|
      t.belongs_to :user
      t.string :type_setting
      t.integer :share_to

      t.timestamps
    end
  end

  def self.down
    drop_table :private_settings
  end
end
