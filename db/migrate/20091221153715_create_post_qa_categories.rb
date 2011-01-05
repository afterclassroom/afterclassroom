class CreatePostQaCategories < ActiveRecord::Migration
  def self.up
    create_table :post_qa_categories do |t|
      t.string :name
    end
    
    ["QA Category A",
      "QA Category B",
      "QA Category C",
     ].each do |s|
        PostQaCategory.new(:name => s).save
      end
  
  end

  def self.down
    drop_table :post_qa_categories
  end
end
