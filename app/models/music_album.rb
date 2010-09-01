# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class MusicAlbum < ActiveRecord::Base
  # Validations
  validates_presence_of :user_id
  validates_presence_of :name

  # Relations
  belongs_to :user
  has_many :musics
  
  # Attach
  has_attached_file :music_album_attach, 
    :default_url => "/images/music.png",
    :styles => { :medium => "555x417>",
    :thumb => "92x68#" }

  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.music_album_attach = data
  end
end
