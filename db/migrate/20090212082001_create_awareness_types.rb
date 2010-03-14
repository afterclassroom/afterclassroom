class CreateAwarenessTypes < ActiveRecord::Migration
  def self.up
    create_table :awareness_types do |t|
      t.string :name, :null => false
    end
    
    ["Take Action Now",
      "Emergency Alerts",
      "What You Don't Know"
    ].each do |s|
      AwarenessType.new(:name => s).save
    end
    
  end

  def self.down
    drop_table :awareness_types
  end
end
