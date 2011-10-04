class CreateUserBlocks < ActiveRecord::Migration
  def self.up
    create_table :user_blocks do |t|
			t.belongs_to :user
			t.integer :user_id_block
      t.timestamps
    end
  end

  def self.down
    drop_table :user_blocks
  end
end
