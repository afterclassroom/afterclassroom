# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class MusicAlbum < ActiveRecord::Base
  # Validations
  validates_presence_of :user_id
  validates_presence_of :name
  
  # Relations
  belongs_to :user
  has_many :musics, :dependent => :destroy
  
  # Comments
  acts_as_commentable
  
  # Favorite
  acts_as_favorite
  
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
  #  validates_attachment_content_type :music_album_attach, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/png']
  
  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.music_album_attach = data
  end
  
  def another_music_albums
    MusicAlbum.find(:all, :limit => 5, :conditions => ["id <> ?", self.id], :order => "created_at DESC")
  end
end