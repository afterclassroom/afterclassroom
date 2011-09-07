class TagInfo < ActiveRecord::Base
  def self.verify(decision, list_of_users,tagable_id)
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users"
    puts"list_of_users == #{list_of_users}"
    TagInfo.update_all({:verify => true}, {:tagable_id => tagable_id, :tagable_type => "Video", :tagable_user => list_of_users})
  end
end
