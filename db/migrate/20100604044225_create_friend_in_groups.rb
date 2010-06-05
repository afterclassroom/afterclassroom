class CreateFriendInGroups < ActiveRecord::Migration
  def self.up
    create_table :friend_in_groups do |t|
      t.belongs_to :friend_group, :null => false
      t.belongs_to :user, :null => false
      t.integer :user_id_friend, :null => false
    end
  end

  def self.down
    drop_table :friend_in_groups
  end
end
