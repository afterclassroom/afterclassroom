class CreateFlirtingUserInchats < ActiveRecord::Migration
  def self.up
    create_table :flirting_user_inchats do |t|
      t.belongs_to :flirting_chanel
      t.belongs_to :user
      t.integer :user_id_invite
      t.string :status, :default => "Invite"
      #There are 3 status
      #Create, Invite, Chat

      t.timestamps
    end
  end

  def self.down
    drop_table :flirting_user_inchats
  end
end
