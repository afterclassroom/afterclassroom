# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class MusicAlbum < ActiveRecord::Base
  # Validations
  validates_presence_of :user_id
  validates_presence_of :name
  
  # Relations
  belongs_to :user
  has_many :musics, :dependent => :destroy
  has_many :rate_text_musics, :dependent => :destroy

  # Comments
  acts_as_commentable
  
  # Favorite
  acts_as_favorite

	# Rating for Like or Unlike
  acts_as_rated :rating_range => 0..1, :with_stats_table => true
  
  # Named Scope
  scope :with_limit, :limit => 6
  scope :with_users, lambda {|u| {:conditions => "user_id IN(#{u})"}}
  scope :most_view, :conditions => "count_view > 0", :order => "count_view DESC"
  
  # Attach
  has_attached_file :music_album_attach, {
    :bucket => 'afterclassroom_musics',
    :default_url => "/images/music.png",
    :styles => { :medium => "555x417>", :thumb => "92x68#" }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  validates_attachment_size :music_album_attach, :less_than => FILE_SIZE_PHOTO
  
  validates_attachment_content_type :music_album_attach, :content_type => ['image/pjpeg', 'image/jpeg', 'image/gif', 'image/png', 'image/x-png']
  
  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    self.music_album_attach = data
  end
  
  def another_music_albums
    self.user.music_albums.find(:all, :limit => 5, :conditions => ["id <> ?", self.id], :order => "rand()")
  end

	def total_good
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end
end
