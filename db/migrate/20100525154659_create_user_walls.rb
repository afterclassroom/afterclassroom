class CreateUserWalls < ActiveRecord::Migration
  def self.up
    create_table :user_walls do |t|
      t.belongs_to :user
      t.integer :user_id_post
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :user_walls
  end
end
