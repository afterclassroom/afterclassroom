class CreatePostExamSchedules < ActiveRecord::Migration
  def self.up
    create_table :post_exam_schedules do |t|
      t.belongs_to :user
      t.belongs_to :school
      t.string :subject
      t.string :teacher_name
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
