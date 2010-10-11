class CreatePostAwarenessesSupports < ActiveRecord::Migration
  def self.up
    create_table :post_awarenesses_supports do |t|
      t.belongs_to :user
      t.belongs_to :post_awareness
      t.boolean :support

      t.timestamps
    end
  end

  def self.down
    drop_table :post_awarenesses_supports
  end
end
