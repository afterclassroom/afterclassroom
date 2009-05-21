class CreatePostEducations < ActiveRecord::Migration
  def self.up
    create_table :post_educations do |t|
      t.belongs_to :post, :null => false
      t.belongs_to :education_category, :null => false
    end
  end

  def self.down
    drop_table :post_educations
  end
end
