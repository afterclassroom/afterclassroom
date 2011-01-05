class CreateHousingCategoriesPostHousings < ActiveRecord::Migration
  def self.up
    create_table :housing_categories_post_housings, :id => false do |t|
      t.belongs_to :housing_category, :null => false
      t.belongs_to :post_housing, :null => false
    end
  end

  def self.down
    drop_table :housing_categories_housings
  end
end
