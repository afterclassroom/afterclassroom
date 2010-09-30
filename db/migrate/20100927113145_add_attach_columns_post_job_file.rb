class AddAttachColumnsPostJobFile < ActiveRecord::Migration
  def self.up

    add_column :post_job_files, :file_name, :string
    add_column :post_job_files, :content_type, :string
    add_column :post_job_files, :file_size, :integer

  end

  def self.down

    remove_column :post_job_files, :file_name
    remove_column :post_job_files, :content_type
    remove_column :post_job_files, :file_size

  end
end
