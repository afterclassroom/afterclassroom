class CreateFlirtingChanels < ActiveRecord::Migration
  def self.up
    create_table :flirting_chanels do |t|
      t.belongs_to :user
      t.integer :user_id_target
      t.string :status, :default => "Invite"
			#There are 3 status
			#Invite, Chat, Stop 
    end
  end

  def self.down
    drop_table :flirting_chanels
  end
end
