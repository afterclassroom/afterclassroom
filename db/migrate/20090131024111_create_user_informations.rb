class CreateUserInformations < ActiveRecord::Migration
  def self.up
    create_table :user_informations do |t|
      t.belongs_to :user, :null => false
      t.string :home_town
      t.string :current_town
      t.boolean :sex
      t.integer :age, :default => 0
      t.string :relationship_status
      t.text :polictical_view
      t.text :interest
      t.text :award
      t.string :i_am_doing

      t.timestamps
    end
  end

  def self.down
    drop_table :user_informations
  end
end
