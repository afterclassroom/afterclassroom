class CreatePostMyxes < ActiveRecord::Migration
  def self.up
    create_table :post_myxes do |t|
      t.belongs_to :post
      t.string :professor
      t.string :rating_status
    end

  end

  def self.down
    drop_table :post_myxes
  end
end
