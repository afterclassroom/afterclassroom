# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class JobType < ActiveRecord::Base
  # Relations
  has_and_belongs_to_many :post_jobs
end
