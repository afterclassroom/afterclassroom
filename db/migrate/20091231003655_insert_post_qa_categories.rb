class InsertPostQaCategories < ActiveRecord::Migration

  def self.up
   ["QA Category A",
    "QA Category B",
    "QA Category C",
   ].each do |s|
      PostQaCategory.new(:name => s).save
    end #END LOOP
  end #END METHOD

  def self.down
  end
  
end
