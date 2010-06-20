class CreateGameapps < ActiveRecord::Migration
  def self.up
    create_table :gameapps do |t|

      t.string :name

      t.string :description

      t.string :playurl

      t.integer :popular_rank

      t.string :state

      t.timestamps

    end
  end

  def self.down
    drop_table :gameapps
  end
end
