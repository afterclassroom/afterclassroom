class CreateLearntools < ActiveRecord::Migration
  def self.up
    create_table :learntools do |t|
      t.belongs_to :user, :null => false    
      t.belongs_to :learn_tool_cate, :null => false  
      t.string :name
      t.text :description
      t.boolean :verify
      t.boolean :authorize
      t.boolean :ac_api
      t.text :href
      t.integer :acc_play_no
      t.integer :client_application_id
      t.timestamps
      #BEGIN columns required for image attachment
      t.string :tool_img_file_name # Original filename
      t.string :tool_img_content_type # Mime type
      t.integer :tool_img_file_size  # File size in bytes
      #END columns required for image attachment
    end
  end

  def self.down
    drop_table :learntools
  end
end
