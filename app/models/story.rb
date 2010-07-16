# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Story < ActiveRecord::Base
  # Relations
  belongs_to :user

  # Comments
  acts_as_commentable

  # Tracker
  acts_as_activity :user

  # State
  acts_as_state_machine :initial => :draft
  state :draft
  state :share
end
