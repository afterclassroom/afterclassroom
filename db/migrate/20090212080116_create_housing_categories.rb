class CreateHousingCategories < ActiveRecord::Migration
  def self.up
    create_table :housing_categories do |t|
      t.string :name
      t.string :label
    end
    
    [
      ["Room for share", "room_for_share"],
      ["Apartment for rent", "apartment_for_rent"],
      ["House for rent", "house_for_rent"],
      ["Summer rental", "summer_rental"]
    ].each do |s|
      HousingCategory.new(:name => s.first, :label => s.last).save
    end
    
  end

  def self.down
    drop_table :housing_categories
  end
end
