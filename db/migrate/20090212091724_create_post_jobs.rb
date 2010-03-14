class CreatePostJobs < ActiveRecord::Migration
  def self.up
    create_table :post_jobs do |t|
      t.belongs_to :post, :null => false
      t.belongs_to :job_type
      t.belongs_to :department
      t.string :school_year
      t.string :address
      t.boolean :prepare_post
      t.text :responsibilities
      t.text :required_skills
      t.text :desirable_skills
      t.text :edu_experience_require
      t.string :compensation
      t.string :rating_status
    end
  end

  def self.down
    drop_table :post_jobs
  end
end
