class CreateShoppingcategories < ActiveRecord::Migration
  def self.up
    create_table :shoppingcategories do |t|

      t.string :name


      t.timestamps

    end
    [
      ["Items For Sale"],
      ["Electonics"],
      ["Verhicles"],
      ["Health & Beauty"]
    ].each do |s|
      Shoppingcategory.new(:name => s.first).save
    end
  end

  def self.down
    drop_table :shoppingcategories
  end
end
