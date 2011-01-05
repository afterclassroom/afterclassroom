class CreateDepartmentCategories < ActiveRecord::Migration
  def self.up
    create_table :department_categories do |t|
      t.string :name, :null => false
    end
  end

  def self.down
    drop_table :department_categories
  end
end
