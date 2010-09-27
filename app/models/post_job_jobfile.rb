class PostJobJobfile < ActiveRecord::Base
  belongs_to :post_job
  
  has_attached_file :job_file
end
