# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Forum < ActiveRecord::Base
  belongs_to :user

  # Comments
  acts_as_commentable
end
