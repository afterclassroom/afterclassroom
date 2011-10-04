class CreateUserWallBlocks < ActiveRecord::Migration
  def self.up
    create_table :user_wall_blocks do |t|
			t.belongs_to :user
			t.belongs_to :user_wall
      t.timestamps
    end
  end

  def self.down
    drop_table :user_wall_blocks
  end
end
