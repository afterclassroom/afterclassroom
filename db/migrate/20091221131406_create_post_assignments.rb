class CreatePostAssignments < ActiveRecord::Migration
  def self.up
    create_table :post_assignments do |t|
      t.belongs_to :post
      t.belongs_to :department
      t.string :school_year
      t.string :professor
      t.datetime :due_date
    end
  end

  def self.down
    drop_table :post_assignments
  end
end
