class CreateEventTypes < ActiveRecord::Migration
  def self.up
    create_table :event_types do |t|
      t.string :name
      t.string :label
    end
    
    [
      ["Sport", "sport"],
      ["Social", "social"],
      ["Festival", "festival"],
      ["Music", "music"],
      ["Performing arts", "performing_arts"],
      ["Networking", "networking"],
      ["Conference", "conference"]
    ].each do |s|
      EventType.new(:name => s.first, :label => s.last).save
    end
    
  end

  def self.down
    drop_table :event_types
  end
end
