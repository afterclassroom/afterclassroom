class CreateUserWallPhotos < ActiveRecord::Migration
  def self.up
    create_table :user_wall_photos do |t|
      t.belongs_to :user_wall
      t.string :link
    end
  end

  def self.down
    drop_table :user_wall_photos
  end
end
