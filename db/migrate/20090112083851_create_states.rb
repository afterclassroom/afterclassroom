class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.belongs_to :country, :null => false
      t.string :name, :limit => 50, :null => false
      t.string :alias, :limit => 10
    end
  end

  def self.down
    drop_table :states
  end
end
