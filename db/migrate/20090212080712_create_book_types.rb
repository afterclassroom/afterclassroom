class CreateBookTypes < ActiveRecord::Migration
  def self.up
    create_table :book_types do |t|
      t.string :name
    end
    
    ["New books",
    "Used books",
    "Discounted books",
    "Free books"
   ].each do |s|
      BookType.new(:name => s).save
    end
    
  end

  def self.down
    drop_table :book_types
  end
end
