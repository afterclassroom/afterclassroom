class JobInfor < ActiveRecord::Base
  # Comments
  acts_as_commentable
  
  # Named Scope
  scope :previous, lambda { |att| {:conditions => ["job_infors.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["job_infors.id > ?", att], :order => "id ASC"} }
end
