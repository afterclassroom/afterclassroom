class CreateUserEmployments < ActiveRecord::Migration
  def self.up
    create_table :user_employments do |t|
      t.belongs_to :user, :null => false
      t.text :resume
      t.string :current_employer
      t.string :position_current
      t.string :past_employer
      t.string :position_past
      t.string :favourite_company

      t.timestamps
    end
  end

  def self.down
    drop_table :user_employments
  end
end
