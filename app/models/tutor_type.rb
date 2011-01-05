# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class TutorType < ActiveRecord::Base
  # Relations
  has_many :post_tutors
end
