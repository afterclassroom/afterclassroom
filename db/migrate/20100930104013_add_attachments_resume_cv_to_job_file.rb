class AddAttachmentsResumeCvToJobFile < ActiveRecord::Migration
  def self.up

    add_column :job_files, :resume_cv_file_name, :string
    add_column :job_files, :resume_cv_content_type, :string
    add_column :job_files, :resume_cv_file_size, :integer

  end

  def self.down

    remove_column :job_files, :resume_cv_file_name
    remove_column :job_files, :resume_cv_content_type
    remove_column :job_files, :resume_cv_file_size

  end
end
