class InsertFunctionalExperience < ActiveRecord::Migration
  def self.up
    ["Accounting"
    ].each do |s|
      FunctionalExperience.new(:name => s).save
    end
  end

  def self.down
  end
end
