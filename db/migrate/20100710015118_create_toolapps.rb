class CreateToolapps < ActiveRecord::Migration
  def self.up
    create_table :toolapps do |t|

      t.string :name

      t.string :description

      t.string :playurl

      t.integer :popular_rank

      t.string :state


      t.timestamps

    end
  end

  def self.down
    drop_table :toolapps
  end
end
