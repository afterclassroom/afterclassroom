class CreateUserWallLinks < ActiveRecord::Migration
  def self.up
    create_table :user_wall_links do |t|
      t.belongs_to :user_wall
      t.string :link
      t.string :image_link
      t.string :title
      t.text :sub_content
    end
  end

  def self.down
    drop_table :user_wall_links
  end
end
