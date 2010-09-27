class CreatePostJobJobfiles < ActiveRecord::Migration
  def self.up
    create_table :post_job_jobfiles do |t|
      t.string :caption
      t.integer :post_id

      t.timestamps
    end
  end

  def self.down
    drop_table :post_job_jobfiles
  end
end
