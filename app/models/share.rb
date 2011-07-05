class Share < ActiveRecord::Base
  # Relations
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  has_and_belongs_to_many :recipients, :class_name => "User"

  # Attach file
  has_attached_file :attach, {
    :bucket => 'afterclassroom_post'
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  validates_attachment_size :attach, :less_than => FILE_SIZE_SHARE
  
  def self.del_share_expire
    share_files = Share.destroy_all(["created_at < ?", Time.now - 1.week])
  end
end