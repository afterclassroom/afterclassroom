class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.belongs_to :user, :null => false
      t.text :content, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end
