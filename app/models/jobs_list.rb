class JobsList < ActiveRecord::Base
  # Relations
belongs_to :user
belongs_to ost_job
end
