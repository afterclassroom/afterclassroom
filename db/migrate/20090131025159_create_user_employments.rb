class CreateUserEmployments < ActiveRecord::Migration
  def self.up
    create_table :user_employments do |t|
      t.belongs_to :user, :null => false
      t.string :current_employer
      t.string :position_current
      t.string :time_period
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :user_employments
  end
end
