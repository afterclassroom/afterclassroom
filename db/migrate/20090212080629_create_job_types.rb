class CreateJobTypes < ActiveRecord::Migration
  def self.up
    create_table :job_types do |t|
      t.string :name, :null => false
    end
    
    ["Full-time Permanent",
      "Full-time Temporary",
      "Part-time Permanent",
      "Part-time Temporary",
      "Contractor/Consultant",
      "Internship",
      "Other"
    ].each do |s|
      JobType.new(:name => s).save
    end
    
  end

  def self.down
    drop_table :job_types
  end
end
