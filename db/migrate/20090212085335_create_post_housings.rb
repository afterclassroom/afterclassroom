class CreatePostHousings < ActiveRecord::Migration
  def self.up
    create_table :post_housings do |t|
      t.belongs_to :post, :null => false
      t.string :rent, :null => false
      t.string :currency
      t.string :street
      t.string :intersection
      t.string :city
      t.string :state
    end
  end

  def self.down
    drop_table :post_housings
  end
end
