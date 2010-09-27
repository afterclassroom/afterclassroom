class AddAttachmentsJobFileToPostJobJobfile < ActiveRecord::Migration
  def self.up

    add_column :post_job_jobfiles, :job_file_file_name, :string
    add_column :post_job_jobfiles, :job_file_content_type, :string
    add_column :post_job_jobfiles, :job_file_file_size, :integer

  end

  def self.down

    remove_column :post_job_jobfiles, :job_file_file_name
    remove_column :post_job_jobfiles, :job_file_content_type
    remove_column :post_job_jobfiles, :job_file_file_size

  end
end
