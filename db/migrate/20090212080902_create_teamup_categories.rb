class CreateTeamupCategories < ActiveRecord::Migration
  def self.up
    create_table :teamup_categories do |t|
      t.string :name, :null => false
    end
    
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
    drop_table :teamup_categories
  end
end
