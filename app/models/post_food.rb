class PostFood < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  
  # Relations
  belongs_to :post
  has_one :rating_statistic
  has_many :ratings

  # Tags
  acts_as_taggable

  # Rating for Bad, Cheap but Good, Good
  # Bad: 0
  # Cheap but Good: 1
  # Good: 2
  acts_as_rated :rating_range => 0..2, :with_stats_table => true

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :with_status, lambda { |st| {:conditions => ["rating_status = ?", st]} }
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "created_at DESC"}}
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["post_foods.id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["post_foods.id > ?", att]} }

  def self.paginated_post_conditions_with_option(params, school, rating_status)
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_foods = PostFood.ez_find(:all, :include => [:post]) do |post_food, post|
      post_food.rating_status == rating_status
      post.school_id == with_school if with_school
    end

    posts = []
    post_foods.select {|p| posts << p.post}
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

  def self.top_food_posters
    type_name = "PostFood"
    limit = 15
    objs = Post.find_by_sql("SELECT id, (SELECT COUNT(posts.id) FROM posts WHERE posts.user_id = users.id AND type_name = '#{type_name}') AS post_total FROM users ORDER BY post_total DESC LIMIT #{limit}")
    arr_id = objs.collect(&:id)
    users = []
    arr_id.each do |id|
      users << User.find(id)
    end
    users
  end

  def total_good
    self.ratings.count(:conditions => ["rating = ?", 2])
  end

  def total_cheap_but_good
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end

  def score_good
    total = self.total_good + self.total_cheap_but_good + self.total_bad
    (total) == 0 ? 0 : (self.total_good.to_f/(total))*100
  end

  def score_cheap_but_good
    total = self.total_good + self.total_cheap_but_good + self.total_bad
    (total) == 0 ? 0 : (self.total_cheap_but_good.to_f/(total))*100
  end

  def score_bad
    total = self.total_good + self.total_cheap_but_good + self.total_bad
    (total) == 0 ? 0 : (self.total_bad.to_f/(total))*100
  end
end
