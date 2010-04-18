class CreateAwarenessTypes < ActiveRecord::Migration
  def self.up
    create_table :awareness_types do |t|
      t.string :name
      t.string :label
    end
    
    [
      ["Take Action Now", "take_action_now"],
      ["Emergency Alerts", "emergency_alerts"],
      ["What You Don't Know", "what_you_dont_know"]
    ].each do |s|
      AwarenessType.new(:name => s.first, :label => s.last).save
    end
    
  end

  def self.down
    drop_table :awareness_types
  end
end
