class PostEvent < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  
  # Relations
  belongs_to :post
  belongs_to :event_type
  has_one :rating_statistic
  has_many :ratings

  # Tags
  acts_as_taggable_on :tags

  # Rating for Bad, Good
  # Bad: 0
  # Good: 1
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :with_status, lambda { |st| {:conditions => ["post_events.rating_status = ?", st]} }
  scope :with_type, lambda {|tp| {:conditions => ["event_type_id = ?", tp]} }
  scope :recent, {:joins => :post, :order => "created_at DESC"}
  scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "posts.created_at DESC"}}
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_events.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["post_events.id > ?", att], :order => "id ASC"} }

  def self.paginated_post_conditions_with_option(params, school, event_type_id)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_events = PostEvent.ez_find(:all, :include => [:post, :event_type], :order => "posts.created_at DESC") do |post_event, post, event_type|
      post.department_id == department if department
      post.school_year == year if year
      event_type.id == event_type_id
      post.school_id == with_school if with_school
      post.created_at > Time.now - over.day
    end

    posts = []
    post_events.select {|p| posts << p.post}
    return posts
  end
  
  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(@school).tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end
  
  def self.related_posts(school, type_id)
    posts = []
    post_as = self.random(5).with_school(school).with_type(type_id)
    post_as.select {|p| posts << p.post}
    posts
  end

  def self.top_event_posters(school)
    type_name = "PostEvent"
    limit = 15
    if school
      objs = Post.find_by_sql("SELECT id, (SELECT COUNT(posts.id) FROM posts WHERE posts.user_id = users.id AND type_name = '#{type_name}' AND posts.school_id = #{school}) AS post_total FROM users ORDER BY post_total DESC LIMIT #{limit}")
    else
      objs = Post.find_by_sql("SELECT id, (SELECT COUNT(posts.id) FROM posts WHERE posts.user_id = users.id AND type_name = '#{type_name}') AS post_total FROM users ORDER BY post_total DESC LIMIT #{limit}")
    end
    users = []
    objs.each do |ob|
      users << User.find(ob[:id]) if ob[:post_total].to_i > 0
    end
    users
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
end
