class InsertEducationCategories < ActiveRecord::Migration
  def self.up
    ["Study Group",
      "Class",
      "Lecture",
      "Office Hours",
      "Workshop",
      "Year Book",
      "Test Schedule",
      "Midterm Schedule",
      "Exam Schedule",
      "Scholarship",
      "Honor List",
      "Counselor Schedule"
    ].each do |s|
      EducationCategory.new(:name => s).save
    end
  end

  def self.down
  end
end

