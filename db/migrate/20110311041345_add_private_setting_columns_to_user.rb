class AddPrivateSettingColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :private_settings,    :string
  end

  def self.down
    remove_column :users, :private_settings,    :string
  end
end
