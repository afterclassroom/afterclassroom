class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :photo_album, :null => false
      t.string :title
      t.text :description
      t.integer :count_view, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
