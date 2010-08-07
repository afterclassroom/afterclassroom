class CreateSellingItems < ActiveRecord::Migration
  def self.up
    create_table :selling_items do |t|

      t.belongs_to :user, :null => false
      t.belongs_to :shopping_subcategory, :null => false
      t.string :name
      t.string :description
      t.string :price


      t.timestamps

    end
  end

  def self.down
    drop_table :selling_items
  end
end
