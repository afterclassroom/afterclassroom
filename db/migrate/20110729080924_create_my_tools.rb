class CreateMyTools < ActiveRecord::Migration
  def self.up
    create_table :my_tools do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :my_tools
  end
end
