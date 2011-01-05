class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name, :limit => 100, :null => false
      t.belongs_to :state, :null => false
      t.belongs_to :country, :null => false
    end
  end

  def self.down
    drop_table :cities
  end
end
