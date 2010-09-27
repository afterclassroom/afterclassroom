# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostJob < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post
  belongs_to :job_type
  belongs_to :department
  has_one :rating_statistic
  has_many :ratings

  has_many :post_job_jobfiles, :dependent => :destroy


  # Tags
  acts_as_taggable

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :with_type, lambda { |tp| {:conditions => ["job_type_id = ?", tp]} }
  named_scope :with_status, lambda { |st| {:conditions => ["rating_status = ?", st]} }
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "created_at DESC"}}
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["post_jobs.id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["post_jobs.id > ?", att]} }

  def self.paginated_post_conditions_with_option(params, school, type_id)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_jobs = PostJob.ez_find(:all, :include => [:post, :job_type], :order => "posts.created_at DESC") do |post_job, post, job_type|
      job_type.id == type_id
      post_job.department_id == department if department
      post_job.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > Time.now - over.day
    end

    posts = []
    post_jobs.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_more_like_this(params, post_like)
    post_ts = PostJob.ez_find(:all, :include => [:post, :job_type], :order => "posts.created_at DESC") do |post_job, post, job_type|
      job_type.id == post_like.post_job.job_type_id
      post_job.department_id == post_like.post_job.department_id
      post_job.school_year == post_like.post_job.school_year
      post.school_id == post_like.school_id
    end

    posts = []
    post_ts.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end
  
  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(@school).find_tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_good_companies(params, school)
    posts = []
    post_as = self.good_companies(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_bad_bosses(params, school)
    posts = []
    post_as = self.bad_bosses(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.related_posts(school)
    posts = []
    post_as = self.with_school(school).random(5)
    post_as.select {|p| posts << p.post}
    posts
  end

  def self.good_companies(school)
    post_jobs = self.with_school(school).with_status("Good")
  end

  def self.bad_bosses(school)
    post_jobs = self.with_school(school).with_status("Bad")
  end

  def self.require_rating(school)
    post_jobs = self.with_school(school).with_status("Require Rating").random(1)
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
