class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.belongs_to :user
      t.belongs_to :post_qa
      t.integer :thumb_up
      t.integer :thumb_down

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
