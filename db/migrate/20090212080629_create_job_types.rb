class CreateJobTypes < ActiveRecord::Migration
  def self.up
    create_table :job_types do |t|
      t.string :name, :null => false
    end
    
    ["Full time",
      "Part time",
      "Co-op/Intern"
    ].each do |s|
      JobType.new(:name => s).save
    end
    
  end

  def self.down
    drop_table :job_types
  end
end
