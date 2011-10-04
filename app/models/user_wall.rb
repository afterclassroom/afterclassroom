class UserWall < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :user_post, :class_name => 'User', :foreign_key => 'user_id_post'
  has_one :user_wall_photo, :dependent => :destroy
  has_one :user_wall_video, :dependent => :destroy
  has_one :user_wall_music, :dependent => :destroy
  has_one :user_wall_link, :dependent => :destroy
  has_one :user_wall_post, :dependent => :destroy
	has_many :user_wall_blocks, :dependent => :destroy
	has_many :user_wall_follows, :dependent => :destroy

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
    !self.user_wall_photo.nil? || !self.user_wall_video.nil? || !self.user_wall_music.nil? || !self.user_wall_link.nil? || !self.user_wall_post.nil?
  end
end
