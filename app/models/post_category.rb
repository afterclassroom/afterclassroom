# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostCategory < ActiveRecord::Base
  # Validations

  # Relations
  has_many :posts
end
