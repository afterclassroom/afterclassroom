class AddOnlineColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :online, :boolean, :default => false
  end

  def self.down
    remove_column :users, :online
  end
end
