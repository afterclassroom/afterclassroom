class InsertAwarenessIssues < ActiveRecord::Migration
  def self.up
    ["Politics",
      "Environments",
      "Student Health"
    ].each do |s|
      AwarenessIssue.new(:name => s).save
    end
  end

  def self.down
  end
end
