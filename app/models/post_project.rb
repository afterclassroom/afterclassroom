# Â© Copyright 2009 AfterClassroom.com â€” All Rights Reserved
class PostProject < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post, :dependent => :destroy
  
  # Tags
  acts_as_taggable_on :tags

  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :recent, {:joins => :post, :order => "posts.created_at DESC"}
  scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "posts.created_at DESC"}}
  scope :due_date, :conditions => ["post_projects.due_date > ?", Time.now], :order => "due_date ASC"
  scope :interesting, :conditions => ["(Select Count(*) From favorites Where favorites.favorable_id = post_projects.post_id And favorable_type = ?) > ?", "Post", 10], :order => "id DESC"
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_projects.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["post_projects.id > ?", att], :order => "id ASC"} }

  def self.paginated_post_conditions_with_option(params, school)
    over = params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_ts = PostProject.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_project, post|
      post.department_id == department if department
      post.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > over.business_days.before(Time.now) if over > 0
    end

    posts = []
    post_ts.select {|p| posts << p.post}
    return posts
  end

  def self.paginated_post_more_like_this(params, post_like)
    post_ts = PostProject.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_project, post|
      post.department_id == post_like.department_id
      post.school_year == post_like.school_year
      post.school_id == post_like.school_id
    end

    posts = []
    post_ts.select {|p| posts << p.post}
    return posts
  end

  def self.paginated_post_conditions_with_due_date(params, school)
    posts = []
    post_as = self.due_date.with_school(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_interesting(params, school)
    self.recent_interesting(school)
#    posts = []
#    post_as = self.with_school(school).interesting
#    post_as.select {|p| posts << p.post}
#    return posts
  end

  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(school).tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end
  
  def self.related_posts(school)
    posts = []
    post_as = self.random(5).with_school(school)
    post_as.select {|p| posts << p.post}
    posts
  end
  
  def self.recent_interesting(school_id)
    objs = Post.recent_interesting(school_id,"post_projects")
  end
  
end
