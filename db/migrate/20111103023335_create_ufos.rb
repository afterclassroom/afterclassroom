class CreateUfos < ActiveRecord::Migration
  def self.up
    create_table :ufos do |t|
      t.belongs_to :user, :null => false
      t.string :title
      t.text :content
      t.string :ufo_attach_file_name
      t.string :ufo_attach_content_type
      t.integer :ufo_attach_file_size
      t.datetime :ufo_attach_updated_at


      t.timestamps
    end
  end

  def self.down
    drop_table :ufos
  end
end
