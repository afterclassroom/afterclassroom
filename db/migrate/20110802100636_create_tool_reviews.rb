class CreateToolReviews < ActiveRecord::Migration
  def self.up
    create_table :tool_reviews do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :tool_reviews
  end
end
