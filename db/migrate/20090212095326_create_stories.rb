class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.belongs_to :user, :null => false
      t.string :title, :null => false
      t.text :content
      t.integer :count_view, :default => 0
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end
