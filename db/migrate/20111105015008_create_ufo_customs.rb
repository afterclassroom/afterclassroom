class CreateUfoCustoms < ActiveRecord::Migration
  def self.up
    create_table :ufo_customs do |t|
      t.belongs_to :ufo, :null => false
      t.string :share_to_index
      #refer to config/initializers/constans.rb, at OPTIONS_SETTING for text-value of share_to_index
      t.boolean :post_lounge

      t.timestamps
    end
  end

  def self.down
    drop_table :ufo_customs
  end
end
