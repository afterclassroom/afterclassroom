# Â© Copyright 2009 AfterClassroom.com â€” All Rights Reserved
class PostMyx < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :professor

  # Relations
  belongs_to :post
  has_one :rating_statistic
  has_many :ratings

  # Tags
  acts_as_taggable

  # Rating for Bad, Bored, Good
  # Bad: 0
  # Bored: 1
  # Good: 2
  acts_as_rated :rating_range => 0..2, :with_stats_table => true
  
  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :with_status, lambda { |st| {:conditions => ["rating_status = ?", st]} }
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "created_at DESC"}}
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["post_myxes.id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["post_myxes.id > ?", att]} }

  # Tags
  acts_as_taggable

  def self.paginated_post_conditions_with_option(params, school, rating_status)
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_myxs = PostMyx.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_myx, post|
      post_myx.rating_status == rating_status
      post.school_id == with_school if with_school
    end

    posts = []
    post_myxs.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(@school).find_tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.related_posts(school)
    posts = []
    post_as = self.with_school(school).random(5)
    post_as.select {|p| posts << p.post}
    posts
  end

  def self.require_rating(school)
    post_myxs = self.with_school(school).with_status("Require Rating").random(1)
  end
  
  def total_good
    self.ratings.count(:conditions => ["rating = ?", 2])
  end

  def total_bored
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end
  
  def score_good
    total = self.total_good + self.total_bored + self.total_bad
    (total) == 0 ? 0 : (self.total_good.to_f/(total))*100
  end

  def score_bored
    total = self.total_good + self.total_bored + self.total_bad
    (total) == 0 ? 0 : (self.total_bored.to_f/(total))*100
  end

  def score_bad
    total = self.total_good + self.total_bored + self.total_bad
    (total) == 0 ? 0 : (self.total_bad.to_f/(total))*100
  end
end
