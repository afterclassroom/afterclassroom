class JobInfor < ActiveRecord::Base
  # Comments
  acts_as_commentable
  
  # Named Scope
  named_scope :previous, lambda { |att| {:conditions => ["job_infors.id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["job_infors.id > ?", att]} }
end
