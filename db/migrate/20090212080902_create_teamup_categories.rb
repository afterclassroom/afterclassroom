class CreateTeamupCategories < ActiveRecord::Migration
  def self.up
    create_table :teamup_categories do |t|
      t.string :name
      t.string :label
    end
    
    [["Your future team", "your_future_team"],
      ["Teamup for Sports", "teamup_for_sports"],
      ["Teamup for Student Clubs", "teamup_for_student_clubs"],
      ["Teamup for Start-up", "teamup_for_start_up"]
    ].each do |s|
      TeamupCategory.new(:name => s.first, :label => s.last).save
    end
    
  end

  def self.down
    drop_table :teamup_categories
  end
end
