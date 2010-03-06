class InsertPostCategories < ActiveRecord::Migration
  def self.up
   ["Assignments",
    "Tests",
    "Projects",
    "Exams",
    "QAs",
    "Education",
    "Tutors",
    "Books",
    "Jobs",
    "Party",
    "Student Awareness",
    "Housing",
    "Team Up",
    "MyX",
    "Foods"
   ].each do |s|
      PostCategory.new(:name => s).save
    end
  end

  def self.down
  end
end
