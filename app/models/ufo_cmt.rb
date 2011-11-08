class UfoCmt < ActiveRecord::Base
  belongs_to :user
  belongs_to :ufo

  has_attached_file :ucmt_attach, {
    :bucket => 'afterclassroom_ucmt'
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  validates_attachment_size :ucmt_attach, :less_than => FILE_SIZE_POST
end
