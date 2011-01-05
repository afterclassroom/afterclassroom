class CreateActivitiesTable < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id, :limit => 10
      t.string :action, :limit => 50
      t.integer :item_id, :limit => 10
      t.string :item_type
      t.datetime :created_at
    end


  end

  def self.down
    drop_table :activities
  end
end
