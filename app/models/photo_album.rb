# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PhotoAlbum < ActiveRecord::Base
  # Validations
  validates_presence_of :user_id
  validates_presence_of :name

  # Relations
  belongs_to :user
  has_many :photos, :dependent => :destroy
  
  # Comments
  acts_as_commentable

  # Tracker
  acts_as_activity :user

  # Tags
  acts_as_taggable

  # Favorite
  acts_as_favorite
  
  def get_photo
    if self.photos.size > 0
      self.photos.first.photo_attach.url(:thumb)
    else
      "/images/noimg2.png"
    end
  end
  
  def another_photo_albums
    PhotoAlbum.find(:all, :limit => 5, :conditions => ["id <> ?", self.id], :order => "created_at DESC")
  end
end
