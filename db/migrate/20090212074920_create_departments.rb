class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.belongs_to :department_category, :null => false
      t.string :name, :null => false
    end
  end

  def self.down
    drop_table :departments
  end
end
