class CreateUserInvites < ActiveRecord::Migration
  def self.up
    create_table :user_invites do |t|
      t.integer :user_id, :null => false
      t.integer :user_id_target, :null => false
      t.string :code
      t.text :message
      t.boolean :is_accepted
      t.datetime :accepted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :user_invites
  end
end
