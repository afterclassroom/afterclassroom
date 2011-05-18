# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostBook < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  
  # Relations
  belongs_to :post
  belongs_to :book_type
  has_one :rating_statistic
  has_many :ratings

  # Tags
  acts_as_taggable_on :tags

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :with_type, lambda { |tp| {:conditions => ["post_books.book_type_id = ?", tp]} }
  scope :with_status, lambda { |st| {:conditions => ["rating_status = ?", st]} }
  scope :recent, {:joins => :post, :order => "created_at DESC"}
  scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "created_at DESC"}}
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_books.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["post_books.id > ?", att], :order => "id ASC"} }

  def self.paginated_post_conditions_with_option(params, school, type_id)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_books = PostBook.ez_find(:all, :include => [:post, :book_type], :order => "posts.created_at DESC") do |post_book, post, book_type|
      book_type.id == type_id
      post.department_id == department if department
      post.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > Time.now - over.day
    end

    posts = []
    post_books.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_more_like_this(params, post_like)
    post_ts = PostBook.ez_find(:all, :include => [:post, :book_type], :order => "posts.created_at DESC") do |post_book, post, book_type|
      book_type.id == post_like.post_book.book_type_id
      post.department_id == post_like.department_id
      post.school_year == post_like.school_year
      post.school_id == post_like.school_id
    end
with_type
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

  def self.paginated_post_conditions_with_good_books(params, school)
    posts = []
    post_as = self.good_books(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_dont_buy(params, school)
    posts = []
    post_as = self.dont_buy(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end
  
  def self.related_posts(school, type)
    posts = []
    post_as = self.random(5).with_school(school).with_type(type)
    post_as.select {|p| posts << p.post}
    posts
  end

  def self.good_books(school)
    post_books = self.with_school(school).with_status("Good")
  end

  def self.dont_buy(school)
   post_books = self.with_school(school).with_status("Bad")
  end

  def self.require_rating(school)
    post_books = self.with_school(school).with_status("Require Rating").random(1)
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
