class CreatePostQaCategories < ActiveRecord::Migration
  def self.up
    create_table :post_qa_categories do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :post_qa_categories
  end
end
