class CreateUserEducations < ActiveRecord::Migration
  def self.up
    create_table :user_educations do |t|
      t.belongs_to :user, :null => false
      t.string :grad_school
      t.string :college
      t.string :high_school

      t.timestamps
    end
  end

  def self.down
    drop_table :user_educations
  end
end
