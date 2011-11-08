class CreateUfoCmts < ActiveRecord::Migration
  def self.up
    create_table :ufo_cmts do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :ufo_cmts
  end
end
