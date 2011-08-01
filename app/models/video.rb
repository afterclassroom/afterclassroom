# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Video < ActiveRecord::Base
  attr_accessor :t
  # Relations
  belongs_to :user
  has_one :video_file
  
  # Attach
  has_attached_file :video_attach, {
    :path => ":rails_root/tmp/:class/:id/:style.:extension"
  }
  
  validates_attachment_presence :video_attach
  
  validates_attachment_size :video_attach, :less_than => FILE_SIZE_VIDEO
  
  validates_attachment_content_type :video_attach, 
    :content_type => [ 'application/x-mp4',
      'video/x-ms-wmv',
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
      'video/rtx',
      'video/ogg',
      'video/webm',
      'application/vnd.rn-realmedia',
      'application/x-shockwave-flash']
  
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
  state :converted, :enter => :add_file_to_s3
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
  scope :most_view, :conditions => ["count_view > 0 AND state = ?", "converted"], :order => "count_view DESC"
  scope :previous, lambda { |att| {:conditions => ["videos.id < ? AND state = ?", att, "converted"], :order => "id DESC"} }
  scope :nexts, lambda { |att| {:conditions => ["videos.id > ? AND state = ?", att, "converted"], :order => "id DESC"} }
  
  # This method is called from the controller and takes care of the converting
  def convert
    self.convert!
    ss = system(convert_command)
    if ss && $?.exitstatus == 0
      self.converted!
    else
      self.failed!
    end
  end
  
  def add_file_to_s3
    video_file = VideoFile.new()
    video_file.video = self
    video_file.video_attach = File.new(@t)
    if video_file.save
      system("rm -rf #{File.dirname(video_attach.path)}")
    end
  end
  
  protected
  
  # This method creates the ffmpeg command that we'll be using
  def convert_command
    @t = File.join(File.dirname(video_attach.path), "#{ActiveSupport::SecureRandom.hex(16)}.flv")
    s = video_attach.path.split("?")[0]
    command = <<-end_command
      ffmpeg -i #{ s } -ar 22050 -ab 32 -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y #{ @t }
    end_command
    command.gsub!(/\s+/, " ")
  end
end
