class CreateMyTools < ActiveRecord::Migration
  def self.up
    create_table :my_tools do |t|
      
      t.belongs_to :user, :null => false
      t.belongs_to :learntool, :null => false
      t.boolean :favorite #this attribute is for detecting fans of this tool
      t.boolean :play_demo #this attribute is for detecting whether user has played a demo version or not

      t.timestamps
    end
  end

  def self.down
    drop_table :my_tools
  end
end
