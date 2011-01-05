class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string :name, :null => false
      t.belongs_to :city, :null => false
      t.string :type_school, :null => false
      t.string :website
    end
  end

  def self.down
    drop_table :schools
  end
end
