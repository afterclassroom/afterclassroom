class CreateBookTypes < ActiveRecord::Migration
  def self.up
    create_table :book_types do |t|
      t.string :name
      t.string :label
    end
    
    [
      ["New books", "new_books"],
      ["Used books", "used_books"],
      ["Discounted books", "discouted_books"],
      ["Free books", "free_books"],
      ["Your friends needed books", "your_friends_needed_books"]
    ].each do |s|
      BookType.new(:name => s.first, :label => s.last).save
    end
    
  end

  def self.down
    drop_table :book_types
  end
end
