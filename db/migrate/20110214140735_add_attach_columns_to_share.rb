class AddAttachColumnsToShare < ActiveRecord::Migration
  def self.up
    add_column :shares, :attach_file_name,    :string
    add_column :shares, :attach_content_type, :string
    add_column :shares, :attach_file_size,    :integer
    add_column :shares, :attach_updated_at,   :datetime
  end

  def self.down
    remove_column :shares, :attach_file_name
    remove_column :shares, :attach_content_type
    remove_column :shares, :attach_file_size
    remove_column :shares, :attach_updated_at
  end
end
