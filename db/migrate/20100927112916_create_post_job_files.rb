class CreatePostJobFiles < ActiveRecord::Migration
  def self.up
    create_table :post_job_files do |t|
      t.string :caption
      t.integer :post_id

      t.timestamps
    end
  end

  def self.down
    drop_table :post_job_files
  end
end
