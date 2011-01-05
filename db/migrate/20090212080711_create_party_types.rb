class CreatePartyTypes < ActiveRecord::Migration
  def self.up
    create_table :party_types do |t|
      t.string :name
      t.string :label
    end
    
    [
      ["Clubbing", "clubbing"],
      ["In house", "in_house"],
      ["Bar", "bar"],
      ["Poker", "poker"],
      ["Birthday", "birthday"],
      ["Chill out", "chill_out"],
      ["Poker party", "poker_party"],
      ["Halloween party", "halloween_party"],
      ["Formal dance", "formal_dance"],
      ["Potluck", "potluck"]
    ].each do |s|
      PartyType.new(:name => s.first, :label => s.last).save
    end
    
  end

  def self.down
    drop_table :party_types
  end
end
