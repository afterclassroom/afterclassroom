class CreatePartyTypesPostParties < ActiveRecord::Migration
  def self.up
    create_table :party_types_post_parties, :id => false do |t|
      t.belongs_to :post_party, :null => false
      t.belongs_to :party_type, :null => false
    end
  end

  def self.down
    drop_table :party_types_post_parties
  end
end
