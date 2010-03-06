class CreateTutorTypes < ActiveRecord::Migration
  def self.up
    create_table :tutor_types do |t|
      t.string :name
    end
    
    ["Tutor providers",
    "Requested for tutor services"
   ].each do |s|
      TutorType.new(:name => s).save
    end
    
  end

  def self.down
    drop_table :tutor_types
  end
end
