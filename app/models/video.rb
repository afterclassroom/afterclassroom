# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Video < ActiveRecord::Base
  # Relations
  belongs_to :user
  
  # Attach
  has_attached_file :video_attach, {
    :bucket => 'afterclassroom_videos',
    #:styles => { :small => '36x36#', :medium => '72x72#', :large => '115x115#' },
    #:url => '/:class/:id/:style.:content_type_extension',
    #:path => ':rails_root/public/system/video_attaches/:id_partition/:style.:content_type_extension',
    :processors => lambda { |a| a.video? ? [ :video_thumbnail ] : [ :thumbnail ] }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  validates_attachment_size :video_attach, :less_than => FILE_SIZE_VIDEO
  
  # Comments
  acts_as_commentable
  
  # Tracker
  acts_as_activity :user
  
  # Tags
  acts_as_taggable
  
  # Favorite
  acts_as_favorite
  
  # State machine
  acts_as_state_machine :initial => :pending
  state :pending
  state :converting
  state :converted, :enter => :set_new_filename
  state :error
  
  event :convert do
    transitions :from => :pending, :to => :converting
  end
  
  event :converted do
    transitions :from => :converting, :to => :converted
  end
  
  event :failed do
    transitions :from => :converting, :to => :error
  end
  
  # Named Scope
  scope :with_limit, :limit => 6
  scope :with_users, lambda {|u| {:conditions => "user_id IN(#{u})"}}
  scope :most_view, :conditions => "count_view > 0", :order => "count_view DESC"
  scope :previous, lambda { |att| {:conditions => ["videos.id < ?", att], :order => "id DESC"} }
  scope :nexts, lambda { |att| {:conditions => ["videos.id > ?", att], :order => "id DESC"} }
  
  # This method is called from the controller and takes care of the converting
  def convert
    self.convert!
    success = system(convert_command)
    if success && $?.exitstatus == 0
      self.converted!
    else
      self.failure!
    end
  end
  
  def video?
    [ 'application/x-mp4',
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
      'video/rtx' ].include?(video_attach.content_type)
  end
  
  protected
  
  # This method creates the ffmpeg command that we'll be using
  def convert_command
    flv = File.join(File.dirname(video_attach.url), "#{id}.flv")
    File.open(flv, 'w')
    
    command = <<-end_command
    ffmpeg -i #{ video_attach.url } -ar 22050 -ab 32 -acodec mp3 
  -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y #{ flv }
  end_command
    command.gsub!(/\s+/, " ")
  end
  
  # This update the stored filename with the new flash video file
  def set_new_filename
    update_attribute(:video_attach_file_name, "#{id}.flv")
  end
end
