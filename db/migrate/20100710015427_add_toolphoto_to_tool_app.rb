class AddToolphotoToToolApp < ActiveRecord::Migration
  def self.up
    add_column :toolapps, :toolphoto_file_name, :string # Original filename
    add_column :toolapps, :toolphoto_content_type, :string # Mime type
    add_column :toolapps, :toolphoto_file_size, :integer # File size in bytes
  end

  def self.down
    remove_column :toolapps, :toolphoto_file_name
    remove_column :toolapps, :toolphoto_content_type
    remove_column :toolapps, :toolphoto_file_size
  end
end

