class JobInfor < ActiveRecord::Base
  # Comments
  acts_as_commentable
  
  # Named Scope
  scope :previous, lambda { |att| {:conditions => ["job_infors.id < ?", att]} }
  scope :next, lambda { |att| {:conditions => ["job_infors.id > ?", att]} }
end
