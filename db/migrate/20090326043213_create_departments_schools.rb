class CreateDepartmentsSchools < ActiveRecord::Migration
  def self.up
    create_table :departments_schools, :id => false do |t|
      t.belongs_to :school, :null => false
      t.belongs_to :department, :null => false
    end
  end

  def self.down
    drop_table :departments_schools
  end
end
