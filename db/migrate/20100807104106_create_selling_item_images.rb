class CreateSellingItemImages < ActiveRecord::Migration
  def self.up
    create_table :selling_item_images do |t|

      t.string :caption

      t.integer :selling_item_id


      t.timestamps

    end
  end

  def self.down
    drop_table :selling_item_images
  end
end
