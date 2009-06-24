class CreateFlirtingChanels < ActiveRecord::Migration
  def self.up
    create_table :flirting_chanels do |t|
      t.belongs_to :user
      t.integer :user_id_target
      t.string :chanel_name,
      t.string :status, :default => "Invite"
			#There are 4 status
			#Invite, Chat, Stop, End 
    end
  end

  def self.down
    drop_table :flirting_chanels
  end
end
