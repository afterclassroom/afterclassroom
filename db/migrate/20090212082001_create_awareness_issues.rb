class CreateAwarenessIssues < ActiveRecord::Migration
  def self.up
    create_table :awareness_issues do |t|
      t.string :name, :null => false
    end
    
    ["Politics",
      "Environments",
      "Student Health"
    ].each do |s|
      AwarenessIssue.new(:name => s).save
    end
    
  end

  def self.down
    drop_table :awareness_issues
  end
end
