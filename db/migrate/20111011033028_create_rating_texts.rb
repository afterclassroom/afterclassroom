class CreateRatingTexts < ActiveRecord::Migration
  def self.up
    create_table :rating_texts do |t|
      t.integer :rater_id
      t.integer :rated_id
      t.string :rated_type
      t.decimal :rating, :precision => 10, :scale => 0 
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :rating_texts
  end
end
