class UserWall < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :user_post, :class_name => 'User', :foreign_key => 'user_id_post'
  has_many :user_wall_photos
  has_many :user_wall_videos
  has_many :user_wall_links

  # Comments
  acts_as_commentable

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  def total_good
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end

end
