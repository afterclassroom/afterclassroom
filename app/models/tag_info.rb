class TagInfo < ActiveRecord::Base
  
  has_one :tag_photo, :dependent => :destroy
  
  def self.verify_vid(list_of_users,tagable_id)
    TagInfo.update_all({:verify => true}, {:tagable_id => tagable_id, :tagable_type => "Video", :tagable_user => list_of_users})
  end
  def self.verify_photo(list_of_users,tagable_id)
    TagInfo.update_all({:verify => true}, {:tagable_id => tagable_id, :tagable_type => "Photo", :tagable_user => list_of_users})
  end
  def self.refuse_vid(list_of_users,tagable_id)
    TagInfo.destroy_all({:tagable_id => tagable_id, :tagable_type => "Video", :tagable_user => list_of_users})
  end
  def self.refuse_photo(list_of_users,tagable_id)
    TagInfo.destroy_all({:tagable_id => tagable_id, :tagable_type => "Photo", :tagable_user => list_of_users})
  end

  def self.verify_music(list_of_users,tagable_id)
    TagInfo.update_all({:verify => true}, {:tagable_id => tagable_id, :tagable_type => "MusicAlbum", :tagable_user => list_of_users})
  end
  def self.refuse_music(list_of_users,tagable_id)
    TagInfo.destroy_all({:tagable_id => tagable_id, :tagable_type => "MusicAlbum", :tagable_user => list_of_users})
  end

  def self.verify_story(list_of_users,tagable_id)
    TagInfo.update_all({:verify => true}, {:tagable_id => tagable_id, :tagable_type => "Story", :tagable_user => list_of_users})
  end
  def self.refuse_story(list_of_users,tagable_id)
    TagInfo.destroy_all({:tagable_id => tagable_id, :tagable_type => "Story", :tagable_user => list_of_users})
  end
end
