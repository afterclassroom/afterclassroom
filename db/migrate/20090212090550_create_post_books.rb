class CreatePostBooks < ActiveRecord::Migration
  def self.up
    create_table :post_books do |t|
      t.belongs_to :post, :null => false
      t.string :price, :null => false
      t.string :currency
      t.string :accept_payment
      t.belongs_to :shipping_method, :null => false
      t.string :in_stock
    end
  end

  def self.down
    drop_table :post_books
  end
end
