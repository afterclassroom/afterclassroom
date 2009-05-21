# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class AwarenessIssue < ActiveRecord::Base
  # Relations
  has_and_belongs_to_many :post_awarenesses
end
