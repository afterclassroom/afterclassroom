class Share < ActiveRecord::Base
  # Relations
  has_and_belongs_to_many :users

  # Attach file
  has_attached_file :attach, {
    :bucket => 'afterclassroom_post'
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
end
