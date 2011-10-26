class CreateRateTextStories < ActiveRecord::Migration
  def self.up
    create_table :rate_text_stories do |t|
      t.integer :user_id
      t.integer :story_id
      t.string :rated_type
      t.decimal :rating, :precision => 10, :scale => 0 
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :rate_text_stories
  end
end
