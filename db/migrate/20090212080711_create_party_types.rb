class CreatePartyTypes < ActiveRecord::Migration
  def self.up
    create_table :party_types do |t|
      t.string :name, :null => false
    end
    
    ["Clubbing",
      "In house",
      "Par",
      "Poker",
      "Birthday",
      "Chill out",
      "Poker party",
      "Halloween party",
      "Formal dance",
      "Potluck"
    ].each do |s|
      PartyType.new(:name => s).save
    end
    
  end

  def self.down
    drop_table :party_types
  end
end
