class CreateFriendGroups < ActiveRecord::Migration
  def self.up
    create_table :friend_groups do |t|
      t.string :name
      t.string :label
    end

    [
      ["Family members", "family_members"],
      ["Friends from school", "friends_from_school"],
      ["Friends from work", "friends_from_work"],
      ["General Friends", "general_friends"]
    ].each do |s|
      FriendGroup.new(:name => s.first, :label => s.last).save
    end
    
  end

  def self.down
    drop_table :friend_groups
  end
end
