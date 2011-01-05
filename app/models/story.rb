# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Story < ActiveRecord::Base
  # Relations
  belongs_to :user

  # Comments
  acts_as_commentable

  # Favorite
  acts_as_favorite

  # Tracker
  acts_as_activity :user

  # State
  acts_as_state_machine :initial => :draft
  state :draft
  state :share

  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :with_users, lambda {|u| {:conditions => "user_id IN(#{u})"}}
  scope :most_view, :order => "count_view DESC"
end
