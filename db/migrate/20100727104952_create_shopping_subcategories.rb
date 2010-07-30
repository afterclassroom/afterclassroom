class CreateShoppingSubcategories < ActiveRecord::Migration
  def self.up
    create_table :shopping_subcategories do |t|

      t.belongs_to :shoppingcategory, :null => false

      t.string :name


      t.timestamps

    end
  end

  def self.down
    drop_table :shopping_subcategories
  end
end
