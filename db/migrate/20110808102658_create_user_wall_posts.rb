class CreateUserWallPosts < ActiveRecord::Migration
  def self.up
    create_table :user_wall_posts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :user_wall_posts
  end
end
