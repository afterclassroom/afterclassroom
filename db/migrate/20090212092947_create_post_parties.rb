class CreatePostParties < ActiveRecord::Migration
  def self.up
    create_table :post_parties do |t|
      t.belongs_to :post, :null => false
      t.datetime :start_time
      t.datetime :end_time
      t.string :address
    end
  end

  def self.down
    drop_table :post_parties
  end
end
