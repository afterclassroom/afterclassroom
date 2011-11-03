class CreateUfoDefaults < ActiveRecord::Migration
  def self.up
    create_table :ufo_defaults do |t|
      t.belongs_to :user, :null => false
      type_of_share

      t.timestamps
    end
  end

  def self.down
    drop_table :ufo_defaults
  end
end
