class InsertTeamupCategories < ActiveRecord::Migration
  def self.up
    ["Start-up company",
      "Research team",
      "Soccer team",
      "Football team",
      "Baseball team",
      "Chess team"
    ].each do |s|
      TeamupCategory.new(:name => s).save
    end
  end

  def self.down
  end
end