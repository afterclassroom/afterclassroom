class CreateMusics < ActiveRecord::Migration
  def self.up
    create_table :musics do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :music_album, :null => false
      t.string :title
      t.string :artist
      t.integer :length_in_seconds
      t.integer :count_view, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :musics
  end
end
