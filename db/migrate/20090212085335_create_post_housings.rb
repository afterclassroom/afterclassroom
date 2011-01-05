class CreatePostHousings < ActiveRecord::Migration
  def self.up
    create_table :post_housings do |t|
      t.belongs_to :post, :null => false
      t.string :rent
      t.string :currency
      t.string :address
      t.string :phone
      t.string :rating_status
    end
  end

  def self.down
    drop_table :post_housings
  end
end
