class CreatePhotoAlbums < ActiveRecord::Migration
  def self.up
    create_table :photo_albums do |t|
      t.belongs_to :user, :null => false
      t.string :name, :null => false
      t.integer :count_view, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :photo_albums
  end
end
