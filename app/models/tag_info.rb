class TagInfo < ActiveRecord::Base
  
  has_one :tag_photo, :dependent => :destroy
  
  def self.verify(list_of_users,tagable_id)
    TagInfo.update_all({:verify => true}, {:tagable_id => tagable_id, :tagable_type => "Video", :tagable_user => list_of_users})
  end
  def self.refuse(list_of_users,tagable_id)
    TagInfo.destroy_all({:tagable_id => tagable_id, :tagable_type => "Video", :tagable_user => list_of_users})
  end
end
