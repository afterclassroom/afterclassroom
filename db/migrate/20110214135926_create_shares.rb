class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
      t.integer :sender_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end
end
