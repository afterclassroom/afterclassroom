class CreatePhoneappcategories < ActiveRecord::Migration
  def self.up
    create_table :phoneappcategories do |t|

      t.string :name


      t.timestamps

    end
  end

  def self.down
    drop_table :phoneappcategories
  end
end
