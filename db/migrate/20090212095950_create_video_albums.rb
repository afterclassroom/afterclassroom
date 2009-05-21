class CreateVideoAlbums < ActiveRecord::Migration
  def self.up
    create_table :video_albums do |t|
      t.belongs_to :user, :null => false
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :video_albums
  end
end
