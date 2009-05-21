class CreatePostTutors < ActiveRecord::Migration
  def self.up
    create_table :post_tutors do |t|
      t.belongs_to :post
      t.string :tutoring_rate
      t.string :per
      t.string :currency
      t.datetime :from
      t.datetime :to
    end
  end

  def self.down
    drop_table :post_tutors
  end
end
