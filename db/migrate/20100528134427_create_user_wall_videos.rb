class CreateUserWallVideos < ActiveRecord::Migration
  def self.up
    create_table :user_wall_videos do |t|
      t.belongs_to :user_wall
      t.string :link
    end
  end

  def self.down
    drop_table :user_wall_videos
  end
end
