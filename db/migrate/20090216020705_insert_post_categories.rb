class InsertPostCategories < ActiveRecord::Migration
  def self.up
   ["Assignments",
    "Tests",
    "Projects",
    "Exams",
    "Education",
    "Tutors",
    "Books",
    "Jobs",
    "Party",
    "Student Awareness",
    "Housing",
    "Team Up"
   ].each do |s|
      PostCategory.new(:name => s).save
    end
  end

  def self.down
  end
end
