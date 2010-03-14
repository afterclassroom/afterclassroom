class CreatePostAwarenesses < ActiveRecord::Migration
  def self.up
    create_table :post_awarenesses do |t|
      t.belongs_to :post, :null => false
      t.belongs_to :awareness_type
      t.datetime :campaign_start
      t.datetime :campaign_end
    end
  end

  def self.down
    drop_table :post_awarenesses
  end
end
