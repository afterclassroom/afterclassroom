# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostHousing < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :rent

  # Relations
  belongs_to :post
  has_and_belongs_to_many :housing_categories

  # Tags
  acts_as_taggable

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["post_housings.id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["post_housings.id > ?", att]} }

  def self.paginated_post_conditions_with_option(params, school, category_id)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school
    housing_category = HousingCategory.find(category_id)
    arr_id = housing_category.post_housings.select {|ph| ph.id}
    post_housings = PostHousing.ez_find(:all, :include => [:post]) do |post_housing, post|
      id === arr_id
      post.school_id == with_school if with_school
      post.school_year == year if year
      post.department_id == department if department
      post.created_at > Time.now - over.day
    end

    posts = []
    post_housings.select {|p| posts << p.post}
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
end
