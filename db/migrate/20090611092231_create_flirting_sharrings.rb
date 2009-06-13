class CreateFlirtingSharrings < ActiveRecord::Migration
  def self.up
    create_table :flirting_sharrings do |t|
      t.belongs_to :flirting_chanel
      t.belongs_to :user
      t.string :sharring_type
      t.integer :sharring_id
      t.boolean :accepted

    end
  end

  def self.down
    drop_table :flirting_sharrings
  end
end
