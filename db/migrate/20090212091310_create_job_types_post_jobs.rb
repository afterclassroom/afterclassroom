class CreateJobTypesPostJobs < ActiveRecord::Migration
  def self.up
    create_table :job_types_post_jobs, :id => false do |t|
      t.belongs_to :post_job, :null => false
      t.belongs_to :job_type, :null => false
    end
  end

  def self.down
    drop_table :job_types_post_jobs
  end
end
