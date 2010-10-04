class CreateJobFiles < ActiveRecord::Migration
  def self.up
    create_table :job_files do |t|
      t.string :category
      t.integer :post_job_id

      t.belongs_to :post_job


      t.timestamps
    end
  end

  def self.down
    drop_table :job_files
  end
end
