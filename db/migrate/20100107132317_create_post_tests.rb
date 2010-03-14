class CreatePostTests < ActiveRecord::Migration
  def self.up
    create_table :post_tests do |t|
      t.belongs_to :post
      t.belongs_to :department
      t.string :school_year
      t.datetime :due_date
    end
  end

  def self.down
    drop_table :post_tests
  end
end
