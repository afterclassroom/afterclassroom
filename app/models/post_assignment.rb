# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAssignment < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  
  # Relations
  belongs_to :post
end
