# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Music < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :music_album

  # Attach
  has_attached_file :music_attach, :content_type => [
    'audio/mp3',
    'audio/wav',
    'audio/mpeg3']

  # Comments
  acts_as_commentable

  # Tracker
  acts_as_activity :user

  #Tags
  acts_as_taggable
end
