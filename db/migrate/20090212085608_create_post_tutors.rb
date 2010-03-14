class CreatePostTutors < ActiveRecord::Migration
  def self.up
    create_table :post_tutors do |t|
      t.belongs_to :post
      t.belongs_to :tutor_type
      t.belongs_to :department
      t.string :school_year
      t.string :address
      t.string :per
      t.string :currency
      t.datetime :from
      t.datetime :to
      t.string :rating_status
    end
  end

  def self.down
    drop_table :post_tutors
  end
end
