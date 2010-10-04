class AddAttachColumnsToJobInfors < ActiveRecord::Migration
  def self.up
    add_column :job_infors, :attach_file_name,    :string
    add_column :job_infors, :attach_content_type, :string
    add_column :job_infors, :attach_file_size,    :integer
    add_column :job_infors, :attach_updated_at,   :datetime
  end

  def self.down
    remove_column :job_infors, :attach_file_name
    remove_column :job_infors, :attach_content_type
    remove_column :job_infors, :attach_file_size
    remove_column :job_infors, :attach_updated_at
  end
end
