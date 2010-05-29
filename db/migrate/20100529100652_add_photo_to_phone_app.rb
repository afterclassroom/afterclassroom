class AddPhotoToPhoneApp < ActiveRecord::Migration
  def self.up
    add_column :phoneapplications, :photo_file_name, :string # Original filename
    add_column :phoneapplications, :photo_content_type, :string # Mime type
    add_column :phoneapplications, :photo_file_size, :integer # File size in bytes
  end

  def self.down
    remove_column :phoneapplications, :photo_file_name
    remove_column :phoneapplications, :photo_content_type
    remove_column :phoneapplications, :photo_file_size
  end
end
