class CreateFriendInvitations < ActiveRecord::Migration
  def self.up
    create_table :friend_invitations do |t|
      t.belongs_to :user
      t.string :email
      t.string :invitation_code
      t.integer :became_user_id
      t.datetime :accepted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :friend_invitations
  end
end
