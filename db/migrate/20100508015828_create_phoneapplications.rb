class CreatePhoneapplications < ActiveRecord::Migration
  def self.up
    create_table :phoneapplications do |t|

      t.belongs_to :phoneappcategory, :null => false

      t.string :name

      t.string :description

      t.string :price

      t.string :playurl


      t.timestamps

    end
  end

  def self.down
    drop_table :phoneapplications
  end
end
