class AddGamephotoToGameApp < ActiveRecord::Migration
  def self.up
    add_column :gameapps, :gamephoto_file_name, :string # Original filename
    add_column :gameapps, :gamephoto_content_type, :string # Mime type
    add_column :gameapps, :gamephoto_file_size, :integer # File size in bytes
  end

  def self.down
    remove_column :gameapps, :gamephoto_file_name
    remove_column :gameapps, :gamephoto_content_type
    remove_column :gameapps, :gamephoto_file_size
  end
end

