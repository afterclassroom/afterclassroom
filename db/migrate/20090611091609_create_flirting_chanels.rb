class CreateFlirtingChanels < ActiveRecord::Migration
  def self.up
    create_table :flirting_chanels do |t|
      t.string :chanel_name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :flirting_chanels
  end
end
