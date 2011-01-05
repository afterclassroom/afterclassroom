class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :video_album, :null => false
      t.string :title
      t.text :description
      t.integer :who_can_see, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
