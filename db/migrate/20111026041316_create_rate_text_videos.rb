class CreateRateTextVideos < ActiveRecord::Migration
  def self.up
    create_table :rate_text_videos do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :video, :null => false
      t.string :rated_type
      t.decimal :rating, :precision => 10, :scale => 0 
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :rate_text_videos
  end
end
