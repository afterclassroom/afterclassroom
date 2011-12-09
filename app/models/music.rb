# encoding: UTF-8
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'mime/types'
class Music < ActiveRecord::Base
	before_create :change_file_name
  # Relations
  belongs_to :user
  belongs_to :music_album
  
  # Attach
  has_attached_file :music_attach, {
    :bucket => 'afterclassroom_musics'
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  validates_attachment_presence :music_attach
  
  validates_attachment_size :music_attach, :less_than => FILE_SIZE_MUSIC
  
  validates_attachment_content_type :music_attach, :content_type => ['audio/mp3', 'audio/wav', 'audio/mpeg']
  
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
  scope :previous, lambda { |att| {:conditions => ["musics.id < ?", att], :order => "id DESC"} }
  scope :nexts, lambda { |att| {:conditions => ["musics.id > ?", att], :order => "id DESC"} }
  
  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    self.music_attach = data
  end
  
  def convert_seconds_to_time
    str = ""
    if length_in_seconds && length_in_seconds > 0
      total_minutes = length_in_seconds / 1.minutes
      seconds_in_last_minute = length_in_seconds - total_minutes.minutes.seconds
      str = "#{total_minutes}m #{seconds_in_last_minute}s"
    else
      str = ""
    end
  end

	def total_good
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end

	private
    def change_file_name
      unless music_attach_file_name.nil?
        self.music_attach.instance_write(:file_name, "#{music_attach_file_name.gsub("'", "`")}")
      end
    end
end
