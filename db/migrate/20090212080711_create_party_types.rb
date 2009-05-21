class CreatePartyTypes < ActiveRecord::Migration
  def self.up
    create_table :party_types do |t|
      t.string :name, :null => false
    end
  end

  def self.down
    drop_table :party_types
  end
end
