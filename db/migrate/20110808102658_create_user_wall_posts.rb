class CreateUserWallPosts < ActiveRecord::Migration
  def self.up
    create_table :user_wall_posts do |t|
      t.belongs_to :user_wall
      t.string :post_type
      t.integer :post_id
    end
  end

  def self.down
    drop_table :user_wall_posts
  end
end
