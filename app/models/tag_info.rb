class TagInfo < ActiveRecord::Base
  def self.verify(decision, list_of_users,tagable_id)
    puts "decision == #{decision};;; list == #{list_of_users}"
    TagInfo.update_all({:verify => true}, {:tagable_id => tagable_id, :tagable_type => "Video", :tagable_user => [1,11]})
  end
end
