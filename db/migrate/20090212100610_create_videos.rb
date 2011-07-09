class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.belongs_to :user, :null => false
      t.string :title
      t.text :description
      t.string :category
      t.integer :count_view, :default => 0
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
