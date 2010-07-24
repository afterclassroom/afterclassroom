# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Photo < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :photo_album

  # Attach
  has_attached_file :photo_attach,
    :styles => { :medium => "555x417>",
    :thumb => "92x68>" }
  validates_attachment_content_type :photo_attach, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/png']

  # Comments
  acts_as_commentable

  # Tracker
  acts_as_activity :user

  #Tags
  acts_as_taggable
end
