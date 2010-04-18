class CreateTutorTypes < ActiveRecord::Migration
  def self.up
    create_table :tutor_types do |t|
      t.string :name
      t.string :label
    end
    
    [
      ["Tutor providers", "tutor_provider"],
      ["Requested for tutor services", "request_for_tutor"]
    ].each do |s|
      TutorType.new(:name => s.first, :label => s.last).save
    end
    
  end

  def self.down
    drop_table :tutor_types
  end
end
