class CreateMyTools < ActiveRecord::Migration
  def self.up
    create_table :my_tools do |t|
      
      t.belongs_to :user, :null => false
      t.belongs_to :learntool, :null => false
      t.boolean :favorite #this attribute is for detecting fans of this tool
      

      t.timestamps
    end
  end

  def self.down
    drop_table :my_tools
  end
end
