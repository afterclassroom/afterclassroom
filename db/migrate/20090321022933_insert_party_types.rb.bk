class InsertPartyTypes < ActiveRecord::Migration
  def self.up
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
  end
end