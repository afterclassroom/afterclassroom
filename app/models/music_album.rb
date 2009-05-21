# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class MusicAlbum < ActiveRecord::Base
  # Validations
  validates_presence_of :user_id
  validates_presence_of :name
  # Relations
  belongs_to :user
  has_many :musics
end
