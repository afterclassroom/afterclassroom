class CreateDepartmentCategories < ActiveRecord::Migration
  def self.up
    create_table :department_categories do |t|
      t.string :name, :null => false
			t.string :type_school
    end
  end

  def self.down
    drop_table :department_categories
  end
end
