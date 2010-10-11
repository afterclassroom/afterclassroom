class CreatePartysLists < ActiveRecord::Migration
  def self.up
    create_table :partys_lists do |t|
      t.belongs_to :user
      t.belongs_to :post_party

      t.timestamps
    end
  end

  def self.down
    drop_table :partys_lists
  end
end
