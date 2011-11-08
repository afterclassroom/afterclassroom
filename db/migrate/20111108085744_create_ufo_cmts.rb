class CreateUfoCmts < ActiveRecord::Migration
  def self.up
    create_table :ufo_cmts do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :ufo, :null => false

      t.text :content
      t.string :ucmt_attach_file_name
      t.string :ucmt_attach_content_type
      t.integer :ucmt_attach_file_size
      t.datetime :ucmt_attach_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :ufo_cmts
  end
end
