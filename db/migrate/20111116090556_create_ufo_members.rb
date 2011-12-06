class CreateUfoMembers < ActiveRecord::Migration
  def self.up
    create_table :ufo_members do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :ufo, :null => false
      t.boolean :recev_mail

      t.timestamps
    end
  end

  def self.down
    drop_table :ufo_members
  end
end
