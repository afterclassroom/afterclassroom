class InsertHousingCategories < ActiveRecord::Migration
  def self.up
    ["Room for share",
      "Apartment for rent",
      "House for rent",
      "Summer rental"
    ].each do |s|
      HousingCategory.new(:name => s).save
    end
  end

  def self.down
  end
end
