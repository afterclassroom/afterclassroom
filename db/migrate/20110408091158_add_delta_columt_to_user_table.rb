class AddDeltaColumtToUserTable < ActiveRecord::Migration
  def self.up
    add_column :users, :delta, :boolean, :default => true,
    :null => false
  end

  def self.down
    remove_column :users, :delta
  end
end
