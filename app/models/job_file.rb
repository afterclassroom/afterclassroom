class JobFile < ActiveRecord::Base
  belongs_to :post_job
  
  has_attached_file :resume_cv
end