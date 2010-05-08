class CreatePhoneapplications < ActiveRecord::Migration
  def self.up
    create_table :phoneapplications do |t|

      t.string :category

      t.string :name

      t.string :url

      t.string :description

      t.string :image


      t.timestamps

    end
  end

  def self.down
    drop_table :phoneapplications
  end
end
