class CreateJobInfors < ActiveRecord::Migration
  def self.up
    create_table :job_infors do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :job_infors
  end
end
