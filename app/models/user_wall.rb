class UserWall < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :user_post, :class_name => 'User', :foreign_key => 'user_id_post'

  # Comments
  acts_as_commentable

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true
end
