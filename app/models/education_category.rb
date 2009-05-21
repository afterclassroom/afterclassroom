# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class EducationCategory < ActiveRecord::Base
  # Relations
  has_many :post_educations
end
