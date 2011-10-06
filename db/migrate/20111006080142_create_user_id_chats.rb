class CreateUserIdChats < ActiveRecord::Migration
  def self.up
    create_table :user_id_chats do |t|
			t.belongs_to :user
			t.string :chat_id
			t.string :type
    end
  end

  def self.down
    drop_table :user_id_chats
  end
end
