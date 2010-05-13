class CreatePhoneappcategories < ActiveRecord::Migration
  def self.up
    create_table :phoneappcategories do |t|

      t.string :name


      t.timestamps

    end

    [
    ["iPhone"],
    ["BlackBerry"],
    ["GoogleApp"]
    ].each do |s|
      Phoneappcategory.new(:name => s.first).save
    end

  end

  def self.down
    drop_table :phoneappcategories
  end
end
