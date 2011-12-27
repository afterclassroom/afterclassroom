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

	# Rating for Like or Unlike
  acts_as_rated :rating_range => 0..1, :with_stats_table => true
  
  # Named Scope
  scope :with_limit, :limit => 6
  scope :with_users, lambda {|u| {:conditions => "user_id IN(#{u})"}}
  scope :most_view, :conditions => "count_view > 0", :order => "count_view DESC"
  
  def get_photo
    if self.photos.size > 0
      self.photos.first.photo_attach.url(:thumb)
    else
      "/images/noimg2.png"
    end
  end
  
  def another_photo_albums
    self.user.photo_albums.find(:all, :limit => 5, :conditions => ["id <> ?", self.id], :order => "rand()")
  end
	
	def total_good
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end
end
