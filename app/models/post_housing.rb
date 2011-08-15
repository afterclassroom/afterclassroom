# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostHousing < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post
  has_and_belongs_to_many :housing_categories

  # Tags
  acts_as_taggable_on :tags

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :recent, {:joins => :post, :order => "posts.created_at DESC"}
  scope :with_status, lambda { |st| {:conditions => ["post_housings.rating_status = ?", st]} }
  scope :with_school, lambda { |sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "posts.created_at DESC"} }
  scope :with_category, lambda{ |ct| {:joins => :housing_categories, :conditions => ["housing_categories.id = ?", ct]} }
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_housings.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["post_housings.id > ?", att], :order => "id ASC"} }

  def self.paginated_post_conditions_with_option(params, school, category_id)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school
    arr_id = []
    if category_id != nil
      housing_category = HousingCategory.find(category_id)
      housing_category.post_housings.select {|ph| arr_id << ph.id}
    end
    
    post_housings = PostHousing.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_housing, post|
      post.department_id == department if department
      post.school_year == year if year
      post_housing.id === arr_id if arr_id.size > 0
      post.school_id == with_school if with_school
      post.created_at > over.business_days.before(Time.now)
    end

    posts = []
    post_housings.select {|p| posts << p.post}
    return posts
  end
  
  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(school).tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_good_housing(params, school)
    posts = []
    post_as = self.good_housing(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_worse_housing(params, school)
    posts = []
    post_as = self.worse_housing(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.related_posts(school, category_id)
    posts = []
    if category_id
      post_as = self.random(5).with_school(school).with_category(category_id)
    else
      post_as = self.random(5).with_school(school)
    end
    post_as.select {|p| posts << p.post}
    posts
  end

  def self.good_housing(school)
    post_housings = self.with_school(school).with_status("Good")
  end

  def self.worse_housing(school)
    post_housings = self.with_school(school).with_status("Bad")
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
