class CreatePostEvents < ActiveRecord::Migration
  def self.up
    create_table :post_events do |t|
      t.belongs_to :post
      t.string :address
      t.string :phone
      t.string :rating_status
    end
  end

  def self.down
    drop_table :post_events
  end
end
