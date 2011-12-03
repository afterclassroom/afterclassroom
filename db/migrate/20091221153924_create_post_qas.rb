class CreatePostQas < ActiveRecord::Migration
  def self.up
    create_table :post_qas do |t|
      t.belongs_to :post
      t.string :rating_status
			t.boolean :anonymous
    end
  end

  def self.down
    drop_table :post_qas
  end
end
