class CreateRateTextMusics < ActiveRecord::Migration
  def self.up
    create_table :rate_text_musics do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :music_album, :null => false
      t.string :rated_type
      t.decimal :rating, :precision => 10, :scale => 0 
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :rate_text_musics
  end
end
