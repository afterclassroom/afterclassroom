class CreateHousingCategories < ActiveRecord::Migration
  def self.up
    create_table :housing_categories do |t|
      t.string :name, :null => false
    end
    
    ["Room for share",
      "Apartment for rent",
      "House for rent",
      "Summer rental"
    ].each do |s|
      HousingCategory.new(:name => s).save
    end
    
  end

  def self.down
    drop_table :housing_categories
  end
end
