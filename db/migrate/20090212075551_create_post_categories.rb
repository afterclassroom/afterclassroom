class CreatePostCategories < ActiveRecord::Migration
  def self.up
    create_table :post_categories do |t|
      t.string :name, :null => false
    end
    
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
    drop_table :post_categories
  end
end
