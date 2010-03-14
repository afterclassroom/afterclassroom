class CreatePostFoods < ActiveRecord::Migration
  def self.up
    create_table :post_foods do |t|
      t.belongs_to :post
      t.string :address
      t.string :phone
    end
  end

  def self.down
    drop_table :post_foods
  end
end
