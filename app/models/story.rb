# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Story < ActiveRecord::Base
  # Relations
  belongs_to :user

  # Comments
  acts_as_commentable

  # Favorite
  acts_as_favorite

	# Rating for Like or Unlike
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

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
  scope :with_state, :conditions => "state = 'share'"

  # Squeezes spaces inside the string: "James   Bond  " => "James Bond"
  auto_strip_attributes :title, :squish => true

  # Won't set to null even if string is blank. "   " => ""
  auto_strip_attributes :content, :nullify => false
	
	def total_good
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end
end
