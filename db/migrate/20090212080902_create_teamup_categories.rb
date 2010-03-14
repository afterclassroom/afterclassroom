class CreateTeamupCategories < ActiveRecord::Migration
  def self.up
    create_table :teamup_categories do |t|
      t.string :name, :null => false
    end
    
    ["Teamup for Sports",
      "Teamup for Student Clubs"
    ].each do |s|
      TeamupCategory.new(:name => s).save
    end
    
  end

  def self.down
    drop_table :teamup_categories
  end
end
