# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Video < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :video_album

  # Attach
  has_attached_file :video_attach, :content_type => [ 'application/x-mp4',
    'video/mpeg',
    'video/quicktime',
    'video/x-la-asf',
    'video/x-ms-asf',
    'video/x-msvideo',
    'video/x-sgi-movie',
    'video/x-flv',
    'flv-application/octet-stream',
    'video/3gpp',
    'video/3gpp2',
    'video/3gpp-tt',
    'video/BMPEG',
    'video/BT656',
    'video/CelB',
    'video/DV',
    'video/H261',
    'video/H263',
    'video/H263-1998',
    'video/H263-2000',
    'video/H264',
    'video/JPEG',
    'video/MJ2',
    'video/MP1S',
    'video/MP2P',
    'video/MP2T',
    'video/mp4',
    'video/MP4V-ES',
    'video/MPV',
    'video/mpeg4',
    'video/mpeg4-generic',
    'video/nv',
    'video/parityfec',
    'video/pointer',
    'video/raw',
    'video/rtx' ]

  # Comments
  acts_as_commentable

  # Tracker
  acts_as_activity :user

  # Tags
  # acts_as_taggable
  
end
