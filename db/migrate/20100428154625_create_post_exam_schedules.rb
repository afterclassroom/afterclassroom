class CreatePostExamSchedules < ActiveRecord::Migration
  def self.up
    create_table :post_exam_schedules do |t|
      t.belongs_to :post
      t.string :teacher_name
      t.datetime :due_date
      t.datetime :starts_at
      t.string :place
      t.string :type_name

      t.timestamps
    end
  end

  def self.down
    drop_table :post_exam_schedules
  end
end
