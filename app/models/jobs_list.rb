class JobsList < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :post_job
end
