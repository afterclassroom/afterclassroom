# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTeamup < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :teamup_category_id

  # Relations
  belongs_to :post, :dependent => :destroy
  belongs_to :teamup_category
  has_one :rating_statistic
  has_many :ratings

  # Tags
  acts_as_taggable_on :tags

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  scope :with_limit, :limit => LIMIT
  scope :recent, {:joins => :post, :order => "posts.created_at DESC"}
  scope :with_status, lambda { |st| {:conditions => ["post_teamups.rating_status = ?", st], :order => "id DESC"} }
  scope :with_category, lambda { |c| {:conditions => ["post_teamups.teamup_category_id = ?", c], :order => "id DESC"} }
  scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "posts.created_at DESC"}}
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_teamups.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["post_teamups.id > ?", att], :order => "id ASC"} }

  def self.paginated_post_conditions_with_option(params, school, category_id)
    over = params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_teamups = PostTeamup.ez_find(:all, :include => [:post, :teamup_category], :order => "posts.created_at DESC") do |post_teamup, post, teamup_category|
      post.department_id == department if department
      post.school_year == year if year
      teamup_category.id == category_id
      post.school_id == with_school if with_school
      post.created_at > over.business_days.before(Time.now) if over > 0
    end

    posts = []
    post_teamups.select {|p| posts << p.post}
    return posts
  end

  def self.paginated_post_more_like_this(params, post_like)
    post_teamups = PostTeamup.ez_find(:all, :include => [:post, :teamup_category], :order => "posts.created_at DESC") do |post_teamup, post, teamup_category|
      post.department_id == post_like.department_id
      post.school_year == post_like.school_year
      teamup_category.id == post_like.post_teamup.teamup_category_id
      post.school_id == post_like.school_id
    end

    posts = []
    post_teamups.select {|p| posts << p.post}
    return posts
  end
  
  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(school).tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_good_org(params, school)
    posts = []
    post_as = self.good_org(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_worse_org(params, school)
    posts = []
    post_as = self.worse_org(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end
  
  def self.related_posts(school, category_id)
    posts = []
    post_as = self.random(5).with_school(school).with_category(category_id)
    post_as.select {|p| posts << p.post}
    posts
  end

  def self.good_org(school)
    post_teamups = self.with_school(school).with_status("Good")
  end

  def self.worse_org(school)
    post_teamups = self.with_school(school).with_status("Bad")
  end

  def self.recent_comments(school)
    if school
      Comment.find_by_sql("SELECT comments.* FROM comments RIGHT JOIN posts ON comments.commentable_id = posts.id WHERE comments.commentable_type = 'Post' AND posts.type_name = 'PostTeamup' AND posts.school_id = #{school} ORDER BY comments.created_at DESC LIMIT 5")
    else
      Comment.find_by_sql("SELECT comments.* FROM comments RIGHT JOIN posts ON comments.commentable_id = posts.id WHERE comments.commentable_type = 'Post' AND posts.type_name = 'PostTeamup' ORDER BY comments.created_at DESC LIMIT 5")
    end
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
end
