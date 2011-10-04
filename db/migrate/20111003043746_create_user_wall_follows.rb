class CreateUserWallFollows < ActiveRecord::Migration
  def self.up
    create_table :user_wall_follows do |t|
			t.belongs_to :user
			t.belongs_to :user_wall
			t.integer :count_update
      t.timestamps
    end
  end

  def self.down
    drop_table :user_wall_follows
  end
end
