class CreateFunctionalExperiences < ActiveRecord::Migration
  def self.up
    create_table :functional_experiences do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :functional_experiences
  end
end
