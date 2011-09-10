class CreateTagPhotos < ActiveRecord::Migration
  def self.up
    create_table :tag_photos do |t|
      t.integer :tag_info_id
      t.integer :left
      t.integer :top
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def self.down
    drop_table :tag_photos
  end
end
