# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'mime/types'
class Music < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :music_album

  # Attach
  has_attached_file :music_attach, {
    :bucket => 'afterclassroom_musics',
    :content_type => [
      'audio/mp3',
      'audio/wav',
      'audio/mpeg3']
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
    

  # Comments
  acts_as_commentable

  # Tracker
  acts_as_activity :user

  #Tags
  acts_as_taggable

  # Favorite
  acts_as_favorite

  # Named Scope
  named_scope :with_limit, :limit => 6
  named_scope :with_users, lambda {|u| {:conditions => "user_id IN(#{u})"}}
  named_scope :most_view, :order => "count_view DESC", :group => "music_album_id"

  # ThinkSphinx
  define_index do
    indexes title, :sortable => true
    indexes artist
    has user_id, music_album_id, created_at
  end

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
