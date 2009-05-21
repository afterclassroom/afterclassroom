class CreateHousingCategories < ActiveRecord::Migration
  def self.up
    create_table :housing_categories do |t|
      t.string :name, :null => false
    end
  end

  def self.down
    drop_table :housing_categories
  end
end
