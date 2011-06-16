class Share < ActiveRecord::Base
  # Relations
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  has_and_belongs_to_many :recipients, :class_name => "User"

  # Attach file
  has_attached_file :attach, {
    :bucket => 'afterclassroom_post'
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  def self.del_share_expire
    share_files = ShareFile.find(:all, :conditions => ["created_at < ?", Time.now - 1.week])
    share_files.delete_all
  end
end
