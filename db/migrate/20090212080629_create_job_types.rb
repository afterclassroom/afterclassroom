class CreateJobTypes < ActiveRecord::Migration
  def self.up
    create_table :job_types do |t|
      t.string :name
      t.string :label
    end
    
    [
      ["Full time", "full_time"],
      ["Part time", "part_time"],
      ["Co-op/Intern", "cop_intern"],
      ["I'm looking for job", "i_m_looking_for_job"]
    ].each do |s|
      JobType.new(:name => s.first, :label => s.last).save
    end
    
  end

  def self.down
    drop_table :job_types
  end
end
