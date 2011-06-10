# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'mime/types'
class Music < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :music_album
  
  # Attach
  has_attached_file :music_attach, {
    :bucket => 'afterclassroom_musics'
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  #  validates_attachment_size :music_attach, :less_than => 100.megabytes
  #  validates_attachment_content_type :music_attach, :content_type => ['audio/mp3', 'audio/wav', 'audio/mpeg3']
  
  # Comments
  acts_as_commentable
  
  # Tracker
  acts_as_activity :user
  
  # Tags
  acts_as_taggable
  
  
  # Favorite
  acts_as_favorite
  
  # Named Scope
  scope :with_limit, :limit => 6
  scope :with_users, lambda {|u| {:conditions => "user_id IN(#{u})"}}
  scope :most_view, :conditions => "count_view > 0", :order => "count_view DESC"
  
  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
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
end
