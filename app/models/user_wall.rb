class UserWall < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :user_post, :class_name => 'User', :foreign_key => 'user_id_post'
  has_one :user_wall_photo
  has_one :user_wall_video
  has_one :user_wall_music
  has_one :user_wall_link

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

  def has_attach
    !self.user_wall_photo.nil? || !self.user_wall_video.nil? || !self.user_wall_music.nil? || !self.user_wall_link.nil?
  end
end
