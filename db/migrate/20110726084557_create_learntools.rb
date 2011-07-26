class CreateLearntools < ActiveRecord::Migration
  def self.up
    create_table :learntools do |t|
      t.belongs_to :user, :null => false      
      t.string :name
      t.text :description
      t.boolean :verify
      t.boolean :authorize
      t.text :href
      t.integer :acc_play_no

      t.timestamps
    end
  end

  def self.down
    drop_table :learntools
  end
end
