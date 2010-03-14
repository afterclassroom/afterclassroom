# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTutor < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post
  belongs_to :tutor_type
  belongs_to :department
  has_one :rating_statistic
  has_many :ratings

  # Tags
  acts_as_taggable
  
  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :with_type, lambda { |tp| {:conditions => ["tutor_type_id = ?", tp]} }
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["post_tutors.id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["post_tutors.id > ?", att]} }

  def self.paginated_post_conditions_with_option(params, school, type_id)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_tutors = PostTutor.ez_find(:all, :include => [:post, :tutor_type]) do |post_tutor, post, tutor_type|
      tutor_type.id == type_id
      post_tutor.department_id == department if department
      post_tutor.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > Time.now - over.day
    end

    posts = []
    post_tutors.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_more_like_this(params, post_like)
    post_ts = PostTutor.ez_find(:all, :include => [:post, :tutor_type]) do |post_tutor, post, tutor_type|
      tutor_type.id == post_like.post_tutor.tutor_type_id
      post_tutor.department_id == post_like.post_tutor.department_id
      post_tutor.school_year == post_like.post_tutor.school_year
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
  
  def self.related_posts(school)
    posts = []
    post_as = self.with_school(school).random(5)
    post_as.select {|p| posts << p.post}
    posts
  end

  def self.effective_tutors(school)
    posts = []
    tutor_type = TutorType.find_by_name("Tutor providers")
    post_tutors = self.with_type(tutor_type.id).with_school(school)
    post_tutors.select {|p| posts << p if p.score >= 50}
    posts
  end

  def self.dont_hire(school)
    posts = []
    tutor_type = TutorType.find_by_name("Tutor providers")
    post_tutors = self.with_type(tutor_type.id).with_school(school)
    post_tutors.select {|p| posts << p if 0 < p.score && p.score < 50}
    posts
  end

  def total_good
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end

  def score
    total = self.total_good + self.total_bad
    (total) == 0 ? 0 : (self.total_good.to_f/(total))*100
  end

  def show_score
    "My score (#{self.total_good}/#{self.total_good + self.total_bad})"
  end
end
