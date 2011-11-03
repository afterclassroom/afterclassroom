class CreateUfos < ActiveRecord::Migration
  def self.up
    create_table :ufos do |t|
      t.belongs_to :user, :null => false
      t.string :title
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :ufos
  end
end
