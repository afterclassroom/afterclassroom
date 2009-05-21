class CreateEducationCategories < ActiveRecord::Migration
  def self.up
    create_table :education_categories do |t|
      t.string :name, :null => false
    end
  end

  def self.down
    drop_table :education_categories
  end
end
