class PostQa < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  
  # Relations
  belongs_to :post, :dependent => :destroy
  has_one :rating_statistic
  has_many :ratings

  # Tags
  acts_as_taggable_on :tags

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :with_type, lambda { |tp| tp == "answered" ? {:conditions => ["(Select Count(*) From comments Where comments.commentable_id = post_qas.post_id And comments.commentable_type = 'Post') > ?", 0], :order => "id DESC"} : {:conditions => ["(Select Count(*) From comments Where comments.commentable_id = post_qas.post_id And comments.commentable_type = 'Post') = ?", 0], :order => "id DESC"} }
  scope :recent, {:joins => :post, :conditions => ["(Select Count(*) From comments Where comments.commentable_id = post_qas.post_id And comments.commentable_type = 'Post') = ?", 0], :order => "posts.created_at DESC"}
  scope :with_status, lambda { |st| {:conditions => ["post_qas.rating_status = ?", st], :order => "id DESC"} }
  scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "posts.created_at DESC"}}
  scope :interesting, :conditions => ["(Select Count(*) From favorites Where favorites.favorable_id = post_qas.post_id And favorable_type = ?) > ?", "Post", 10], :order => "id DESC"
  scope :top_answer, :conditions => ["(Select Count(*) From comments Where comments.commentable_id = post_qas.post_id And comments.commentable_type = 'Post') > ?", 10], :order => "id DESC"
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_qas.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["post_qas.id > ?", att], :order => "id ASC"} }

  def self.paginated_post_conditions_with_option(params, school, type)
    if type == "answered"
      self.paginated_post_conditions_with_answered(params, school)
    else
      self.paginated_post_conditions_with_asked(params, school)
    end
  end
  
  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_qa = self.with_school(school).tagged_with(tag_name)
    post_qa.select {|p| arr_p << p.post}
    posts = arr_p.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_answered(params, school)
    over = params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school
    post_qas = PostQa.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_qa, post|
      post.department_id == department if department
      post.school_year == year if year
      post.school_id == with_school if with_school
      post.created_at > over.business_days.before(Time.now) if over > 0
    end
    arr_p = []
    post_qas.select {|p| arr_p << p.post if p.post.comments.size > 0}
    
    return arr_p
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
      post.created_at > over.business_days.before(Time.now)
    end
    arr_p = []
    post_qas.select {|p| arr_p << p.post if p.post.comments.size == 0}
    return arr_p
  end

  def self.paginated_post_conditions_with_interesting(params, school)
#    arr_p = []
#    post_qa = self.with_school(school).interesting
#    post_qa.select {|p| arr_p << p.post if p.post.favorites.size > 10}
#    return arr_p
    self.recent_interesting(school)
  end

  def self.paginated_post_conditions_with_top_answer(params, school)
    arr_p = []
    post_qa = self.with_school(school).top_answer
    post_qa.select {|p| arr_p << p.post}
    
    arr_p1 = arr_p.sort_by { |p| p.comments.size }.reverse! #fixbug 1096
    
    @posts = arr_p1.paginate :page => params[:page], :per_page => 10
  end
  
  def self.related_posts(school, type)
    posts = []
    post_qa = self.random(5).with_school(school).with_type(type)
    post_qa.select {|p| posts << p.post}
    posts
  end

  def self.require_rating(school)
    self.with_school(school).with_status("Require Rating").random(1)
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
  
  def self.recent_interesting(school_id)
    
    objs = Post.recent_interesting(school_id,"post_qas")
    
  end
  
end
