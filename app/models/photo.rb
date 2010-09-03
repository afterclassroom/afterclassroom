# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'mime/types'
class Photo < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :photo_album

  # Attach
  has_attached_file :photo_attach,
#    :storage => :s3,
#    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
#    :bucket => 'afterclassroom_photos',
    :styles => { :medium => "555x417>",
    :thumb => "92x68#" }
  validates_attachment_content_type :photo_attach, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/png']

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
  named_scope :most_view, :order => "count_view DESC", :group => "photo_album_id"

  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.photo_attach = data
  end
end
