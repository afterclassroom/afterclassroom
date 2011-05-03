# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTutor < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post, :dependent => :destroy
  belongs_to :tutor_type
  has_one :rating_statistic
  has_many :ratings

  # Tags
  acts_as_taggable_on :tags

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :with_type, lambda { |tp| {:conditions => ["post_tutors.tutor_type_id = ?", tp]} }
  scope :with_status, lambda { |st| {:conditions => ["post_tutors.rating_status = ?", st]} }
  scope :recent, {:joins => :post, :order => "created_at DESC"}
  scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "created_at DESC"}}
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_tutors.id < ?", att]} }
  scope :next, lambda { |att| {:conditions => ["post_tutors.id > ?", att]} }

  def self.paginated_post_conditions_with_option(params, school, type_id)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_tutors = PostTutor.ez_find(:all, :include => [:post, :tutor_type], :order => "posts.created_at DESC") do |post_tutor, post, tutor_type|
      tutor_type.id == type_id
      post.department_id == department if department
      post.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > Time.now - over.day
    end

    posts = []
    post_tutors.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_more_like_this(params, post_like)
    post_ts = PostTutor.ez_find(:all, :include => [:post, :tutor_type], :order => "posts.created_at DESC") do |post_tutor, post, tutor_type|
      tutor_type.id == post_like.post_tutor.tutor_type_id
      post.department_id == post_like.department_id
      post.school_year == post_like.school_year
      post.school_id == post_like.school_id
    end

    posts = []
    post_ts.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(@school).tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_effective_tutors(params, school)
    posts = []
    post_as = self.effective_tutors(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_dont_hire(params, school)
    posts = []
    post_as = self.dont_hire(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end
  
  def self.related_posts(school, type)
    posts = []
    post_as = self.random(5).with_school(school).with_type(type)
    post_as.select {|p| posts << p.post}
    posts
  end

  def self.effective_tutors(school)   
    tutor_type = TutorType.find_by_label("tutor_provider")
    self.with_type(tutor_type.id).with_school(school).with_status("Good")
  end

  def self.dont_hire(school)
    tutor_type = TutorType.find_by_label("tutor_provider")
    self.with_type(tutor_type.id).with_school(school).with_status("Bad")
  end

  def self.require_rating(school)
    tutor_type = TutorType.find_by_label("tutor_provider")
    self.with_type(tutor_type.id).with_school(school).with_status("Require Rating").random(1)
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

  def show_score
    "My score (#{self.total_good}/#{self.total_good + self.total_bad})"
  end
end
