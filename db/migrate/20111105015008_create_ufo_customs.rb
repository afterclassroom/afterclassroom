class CreateUfoCustoms < ActiveRecord::Migration
  def self.up
    create_table :ufo_customs do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :ufo_customs
  end
end
