class CreateJobsLists < ActiveRecord::Migration
  def self.up
    create_table :jobs_lists do |t|
      t.belongs_to :user
      t.belongs_to :post_job
      
      t.timestamps
    end
  end

  def self.down
    drop_table :jobs_lists
  end
end
