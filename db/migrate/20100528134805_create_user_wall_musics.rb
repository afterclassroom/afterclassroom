class CreateUserWallMusics < ActiveRecord::Migration
  def self.up
    create_table :user_wall_musics do |t|
      t.belongs_to :user_wall
      t.string :link
      t.string :title
      t.text :sub_content
    end
  end

  def self.down
    drop_table :user_wall_musics
  end
end
