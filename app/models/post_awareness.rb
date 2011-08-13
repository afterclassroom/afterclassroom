# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAwareness < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  
  # Relations
  belongs_to :post
  belongs_to :awareness_type
  has_many :post_awarenesses_supports, :dependent => :destroy
  
  # Tags
  acts_as_taggable_on :tags
  
  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true
  
  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :recent, {:joins => :post, :order => "posts.created_at DESC"}
  scope :with_status, lambda { |st| {:conditions => ["post_awarenesses.rating_status = ?", st], :order => "created_at DESC"} }
  scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "posts.created_at DESC"}}
  scope :with_type, lambda { |c| {:conditions => ["post_awarenesses.awareness_type_id = ?", c], :order => "created_at DESC"} }
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_awarenesses.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["post_awarenesses.id > ?", att], :order => "id ASC"} }
  
  def self.paginated_post_conditions_with_option(params, school, awareness_type_id)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school
    
    post_awarenesss = PostAwareness.ez_find(:all, :include => [:post, :awareness_type], :order => "posts.created_at DESC") do |post_awareness, post, awareness_type|
      post.department_id == department if department
      post.school_year == year if year
      awareness_type.id == awareness_type_id
      post.school_id == with_school if with_school
      post.created_at > over.business_days.before(Time.now)
    end
    
    posts = []
    post_awarenesss.select {|p| posts << p.post}
    return posts
  end
  
  def self.paginated_post_more_like_this(params, post_like)
    post_as = PostAwareness.ez_find(:all, :include => [:post, :awareness_type], :order => "posts.created_at DESC") do |post_awareness, post, awareness_type|
      post.department_id == post_like.department_id
      post.school_year == post_like.school_year
      awareness_type.id == post_like.post_awareness.awareness_type_id
      post.school_id == post_like.school_id
    end
    
    posts = []
    post_as.select {|p| posts << p.post}
    return posts
  end
  
  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(school).tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end
  
  def self.related_posts(school, type)
    posts = []
    post_as = if school 
      self.random(5).with_school(school).with_type(type)
    else
      self.random(5).with_type(type)
    end
    post_as.select {|p| posts << p.post}
    posts
  end
  
  def self.goods
    posts = []
    post_as = self.with_school(school)
    post_as.select {|p| posts << p.post if p.score >= 50}
    posts
  end
  
  def self.bads
    posts = []
    post_as = self.with_school(school)
    post_as.select {|p| posts << p.post if p.score < 50}
    posts
  end
  
  def self.recent_comments(school)
    if school
      Comment.find_by_sql("SELECT comments.* FROM comments RIGHT JOIN posts ON comments.commentable_id = posts.id WHERE comments.commentable_type = 'Post' AND posts.type_name = 'PostAwareness' AND posts.school_id = #{school} ORDER BY comments.created_at DESC LIMIT 5")
    else
      Comment.find_by_sql("SELECT comments.* FROM comments RIGHT JOIN posts ON comments.commentable_id = posts.id WHERE comments.commentable_type = 'Post' AND posts.type_name = 'PostAwareness' ORDER BY comments.created_at DESC LIMIT 5")
    end
  end
  
  def self.require_rating(school)
    aware_type = AwarenessType.find_by_name("Take Action Now")
    self.with_type(aware_type.id).with_school(school).with_status("Require Rating").random(1)
  end
  
  def total_good
    self.ratings.count(:conditions => ["rating = ?", 1])
  end
  
  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end
  
  def score_good
    total = self.total_good + self.total_bad
     (total) == 0 ? 0 : (self.total_good.to_f/(total))*100
  end
  
  def score_bad
    total = self.total_good + self.total_bad
     (total) == 0 ? 0 : (self.total_bad.to_f/(total))*100
  end
  
  def total_support
    self.post_awarenesses_supports.where(:support => true).size
  end
  
  def total_notsupport
    self.post_awarenesses_supports.where(:support => false).size
  end
end
