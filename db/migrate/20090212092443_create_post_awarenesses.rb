class CreatePostAwarenesses < ActiveRecord::Migration
  def self.up
    create_table :post_awarenesses do |t|
      t.belongs_to :post, :null => false
      t.belongs_to :awareness_type
      t.datetime :due_date
      t.string :phone
      t.string :rating_status
    end
  end

  def self.down
    drop_table :post_awarenesses
  end
end
