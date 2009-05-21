class CreatePostJobs < ActiveRecord::Migration
  def self.up
    create_table :post_jobs do |t|
      t.belongs_to :post, :null => false
      t.boolean :prepare_post
      t.text :responsibilities, :null => false
      t.text :required_skills, :null => false
      t.text :desirable_skills, :null => false
      t.text :edu_experience_require, :null => false
      t.string :compensation
    end
  end

  def self.down
    drop_table :post_jobs
  end
end
