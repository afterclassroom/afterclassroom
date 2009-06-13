class CreateFlirtingMessages < ActiveRecord::Migration
  def self.up
    create_table :flirting_messages do |t|
      t.belongs_to :flirting_chanel
      t.belongs_to :user
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :flirting_messages
  end
end
