class PostQa < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  
  # Relations
  belongs_to :post_qa_category
  belongs_to :post
  has_one :rating_statistic
  has_many :ratings

  # Tags
  acts_as_taggable

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  # Named Scope
  named_scope :with_limit, :limit => LIMIT
  named_scope :with_category, lambda { |c| {:conditions => ["post_qas.post_qa_category_id = ?", c]} }
  named_scope :recent, {:joins => :post, :conditions => ["(Select Count(*) From comments Where comments.commentable_id = post_qas.post_id And comments.commentable_type = 'Post') = ?", 0], :order => "created_at DESC"}
  named_scope :with_status, lambda { |st| {:conditions => ["post_qas.rating_status = ?", st]} }
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "created_at DESC"}}
  named_scope :interesting, :conditions => ["(Select Count(*) From favorites Where favorites.favorable_id = post_qas.post_id And favorable_type = ?) > ?", "Post", 10]
  named_scope :top_answer, :conditions => ["(Select Count(*) From comments Where comments.commentable_id = post_qas.post_id And comments.commentable_type = 'Post') > ?", 10]
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["post_qas.id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["post_qas.id > ?", att]} }

  def self.paginated_post_conditions_with_option(params, school, type)
    if type == "answered"
      posts = self.paginated_post_conditions_with_answered(params, school)
    else
      posts = self.paginated_post_conditions_with_asked(params, school)
    end
  end
  
  def self.paginated_post_more_like_this(params, post_like)
    type = params[:type]
    type ||= "answered"
    posts_like = PostQa.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_qa, post|
      post.department_id == post_like.department_id
      post.school_year == post_like.school_year
      post_qa.post_qa_category_id == post_like.post_qa.post_qa_category_id
      post.school_id == post_like.school_id
    end
    arr_p = []
    if type == "answered"
      posts_like.select {|p| arr_p << p.post if p.post.comments.size > 0}
    else
      posts_like.select {|p| arr_p << p.post if p.post.comments.size == 0}
    end
    
    posts = arr_p.paginate :page => params[:page], :per_page => 10
  end
  
  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_qa = self.with_school(school).find_tagged_with(tag_name)
    post_qa.select {|p| arr_p << p.post}
    posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_answered(params, school)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school
    post_qas = PostQa.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_qa, post|
      post.department_id == department if department
      post.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > Time.now - over.day
    end
    arr_p = []
    post_qas.select {|p| arr_p << p.post if p.post.comments.size > 0}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_asked(params, school)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school
    post_qas = PostQa.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_qa, post|
      post.department_id == department if department
      post.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > Time.now - over.day
    end
    arr_p = []
    post_qas.select {|p| arr_p << p.post if p.post.comments.size == 0}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_interesting(params, school)
    arr_p = []
    post_qa = self.with_school(school).interesting
    post_qa.select {|p| arr_p << p.post if p.post.favorites.size > 10}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_top_answer(params, school)
    arr_p = []
    post_qa = self.with_school(school).top_answer
    post_qa.select {|p| arr_p << p.post if p.post.comments.size == 0}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end
  
  def self.related_posts(school)
    posts = []
    post_qa = self.with_school(school).random(5)
    post_qa.select {|p| posts << p.post}
    posts
  end

  def self.require_rating(school)
    post_qas = self.with_school(school).with_status("Require Rating").random(1)
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
