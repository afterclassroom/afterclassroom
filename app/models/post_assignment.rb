# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAssignment < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :professor
  validates_presence_of :due_date
  
  # Relations
  belongs_to :post
  belongs_to :department

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :due_date, :conditions => ["due_date > ?", Time.now], :order => "due_date DESC"
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["post_assignments.id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["post_assignments.id > ?", att]} }

  # Tags
  acts_as_taggable
  
  def self.paginated_post_conditions_with_option(params, school)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_as = PostAssignment.ez_find(:all, :include => [:post], :order => "created_at DESC") do |post_assignment, post|
      post_assignment.department_id == department if department
      post_assignment.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > Time.now - over.day
    end

    posts = []
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_more_like_this(params, post_like)
    post_as = PostAssignment.ez_find(:all, :include => [:post]) do |post_assignment, post|
      post_assignment.department_id == post_like.post_assignment.department_id
      post_assignment.school_year == post_like.post_assignment.school_year
      post.school_id == post_like.school_id
    end

    posts = []
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_due_date(params, school)
    posts = []
    post_as = self.with_school(school).due_date
    post_as.select {|p| posts << p.post}
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
end
