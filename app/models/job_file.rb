class JobFile < ActiveRecord::Base
  belongs_to :post_job
  
  has_attached_file :resume_cv, :default_url => ""
  
#  named_scope :with_current_user, lambda { |usr_id| {:conditions => ["job_files.user_id = ?", usr_id]} }
#  named_scope :with_letter, :conditions => { :category =>["Cover Letter"] }
#  named_scope :with_resume, :conditions => { :category =>["Resume"] }
#  named_scope :with_transcript, :conditions => { :category =>["Transcript"] }
  
end
