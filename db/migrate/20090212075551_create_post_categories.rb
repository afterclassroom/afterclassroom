class CreatePostCategories < ActiveRecord::Migration
  def self.up
    create_table :post_categories do |t|
      t.string :name, :null => false
      t.string :class_name, :null => false
    end
    
    [
      ["Assignments", "PostAssignment"],
      ["Tests", "PostTest"],
      ["Projects", "PostProject"],
      ["Exams", "PostExam"],
			["Lecture Notes", "PostLectureNote"],
      ["QAs", "PostQa"],
      ["Tutors", "PostTutor"],
      ["Books", "PostBook"],
      ["Jobs", "PostJob"],
      ["Party", "PostParty"],
      ["Student Awareness", "PostAwareness"],
      ["Housing", "PostHousing"],
      ["Team Up", "PostTeamup"],
      ["MyX", "PostMyx"],
      ["Food", "PostFood"],
      ["Schedules", "PostExamSchedule"],
      ["Events", "PostEvent"]
    ].each do |s|
      PostCategory.new(:name => s.first, :class_name => s.last).save
    end
    
  end

  def self.down
    drop_table :post_categories
  end
end
