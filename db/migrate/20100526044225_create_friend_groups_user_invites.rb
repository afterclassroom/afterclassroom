class CreateFriendGroupsUserInvites < ActiveRecord::Migration
  def self.up
    create_table :friend_groups_user_invites, :id => false do |t|
      t.belongs_to :friend_group, :null => false
      t.belongs_to :user_invite, :null => false
    end
  end

  def self.down
    drop_table :friend_groups_user_invites
  end
end
