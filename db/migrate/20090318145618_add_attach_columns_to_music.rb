class AddAttachColumnsToMusic < ActiveRecord::Migration
  def self.up
    add_column :musics, :music_attach_file_name,    :string
    add_column :musics, :music_attach_content_type, :string
    add_column :musics, :music_attach_file_size,    :integer
    add_column :musics, :music_attach_updated_at,   :datetime
  end

  def self.down
    remove_column :musics, :music_attach_file_name
    remove_column :musics, :music_attach_content_type
    remove_column :musics, :music_attach_file_size
    remove_column :musics, :music_attach_updated_at
  end
end
