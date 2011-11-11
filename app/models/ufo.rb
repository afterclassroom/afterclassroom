class Ufo < ActiveRecord::Base
  belongs_to :user
  has_one :ufo_custom, :dependent => :destroy
  has_many :ufo_cmts, :dependent => :destroy

  has_attached_file :ufo_attach, {
    :bucket => 'afterclassroom_ufo'
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  validates_attachment_size :ufo_attach, :less_than => FILE_SIZE_POST

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true
end
