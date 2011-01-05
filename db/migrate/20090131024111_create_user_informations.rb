class CreateUserInformations < ActiveRecord::Migration
  def self.up
    create_table :user_informations do |t|
      t.belongs_to :user, :null => false
      t.string :current_city
      t.text :looking_for
      t.boolean :sex
      t.date :birthday
      t.string :mobile_number
      t.string :website
      t.string :relationship_status
      t.text :polictical_view
      t.string :about_yourself

      t.timestamps
    end
  end

  def self.down
    drop_table :user_informations
  end
end
