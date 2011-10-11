# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'mime/types'
class Photo < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :photo_album

  # Attach
  has_attached_file :photo_attach, {
    :bucket => 'afterclassroom_photos',
    :styles => { :medium => "555x417>", :thumb => "92x68#" }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  validates_attachment_presence :photo_attach
  
  validates_attachment_size :photo_attach, :less_than => FILE_SIZE_PHOTO
  
  validates_attachment_content_type :photo_attach, :content_type => ['image/pjpeg', 'image/jpeg', 'image/gif', 'image/png', 'image/x-png']

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
  scope :most_view, :conditions => "count_view > 0", :order => "count_view DESC", :group => "photo_album_id"
  scope :previous, lambda { |att| {:conditions => ["photos.id < ?", att], :order => "id DESC"} }
  scope :nexts, lambda { |att| {:conditions => ["photos.id > ?", att], :order => "id DESC"} }
  
  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    self.photo_attach = data
  end
end
