class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites do |t|
      t.belongs_to :user
      t.belongs_to :post
      
      t.timestamps
    end
  end

  def self.down
    drop_table :favorites
  end
end
