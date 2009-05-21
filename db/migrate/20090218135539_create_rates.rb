class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.references :post
      t.references :rateable, :polymorphic => true
      t.integer :stars

      t.timestamps
    end
    
    add_index :rates, :post_id
    add_index :rates, :rateable_id
  end

  def self.down
    drop_table :rates
  end
end
