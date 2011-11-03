class CreateUfos < ActiveRecord::Migration
  def self.up
    create_table :ufos do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :ufos
  end
end
