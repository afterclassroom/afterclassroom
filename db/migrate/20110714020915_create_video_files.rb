class CreateVideoFiles < ActiveRecord::Migration
  def self.up
    create_table :video_files do |t|
      t.belongs_to :video, :null => false
      t.string :video_attach_file_name
      t.string :video_attach_content_type
      t.integer :video_attach_file_size
      t.datetime :video_attach_updated_at
    end
  end

  def self.down
    drop_table :video_files
  end
end
