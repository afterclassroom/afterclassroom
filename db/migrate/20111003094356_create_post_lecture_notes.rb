class CreatePostLectureNotes < ActiveRecord::Migration
  def self.up
    create_table :post_lecture_notes do |t|
      t.belongs_to :post
      t.string :professor
      t.datetime :due_date
    end
  end

  def self.down
    drop_table :post_lecture_notes
  end
end
