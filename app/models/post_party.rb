# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostParty < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post, :dependent => :destroy
  has_many :post_party_rsvps, :dependent => :destroy
  has_and_belongs_to_many :party_types
  has_one :rating_statistic
  has_many :ratings

  # Tags
  acts_as_taggable_on :tags

  # Rating for Bad, Ok, Good
  # Bad: 0
  # It's Ok: 1
  # Good: 2
  acts_as_rated :rating_range => 0..2, :with_stats_table => true

  # Named Scope
  scope :with_limit, :limit => LIMIT
  scope :with_status, lambda { |st| {:conditions => ["post_parties.rating_status = ?", st]} }
  scope :recent, {:joins => :post, :order => "created_at DESC"}
  scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc], :order => "posts.created_at DESC"}}
  scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  scope :previous, lambda { |att| {:conditions => ["post_parties.id < ?", att], :order => "id ASC"} }
  scope :nexts, lambda { |att| {:conditions => ["post_parties.id > ?", att], :order => "id ASC"} }

  def self.paginated_post_conditions_with_option(params, school, rating_status)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]
    from_school = params[:from_school]
    with_school = school
    with_school = from_school if from_school

    post_parties = PostParty.ez_find(:all, :include => [:post], :order => "posts.created_at DESC") do |post_party, post|
      post.department_id == department if department
      post.school_year == year if year
      post_party.rating_status == rating_status
      post.school_id == with_school if with_school
      post.created_at > Time.now - over.day
    end

    posts = []
    post_parties.select {|p| posts << p.post}
    return posts
  end
  
  def self.paginated_post_conditions_with_tag(params, school, tag_name)
    arr_p = []
    post_as = self.with_school(school).tagged_with(tag_name)
    post_as.select {|p| arr_p << p.post}
    @posts = arr_p.paginate :page => params[:page], :per_page => 10
  end


  def self.related_posts(school, status)
    posts = []
    if status
      post_as = self.random(5).with_school(school).with_status(status)
    else
      post_as = self.random(5).with_school(school)
    end
    post_as.select {|p| posts << p.post}
    posts
  end

  def self.top_party_posters(school)
    type_name = "PostParty"
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
    post_parties = self.with_school(school).with_status("Require Rating").random(1)
  end

  def total_good
    self.ratings.count(:conditions => ["rating = ?", 2])
  end

  def total_ok
    self.ratings.count(:conditions => ["rating = ?", 1])
  end

  def total_bad
    self.ratings.count(:conditions => ["rating = ?", 0])
  end

  def score_good
    total = self.total_good + self.total_ok + self.total_bad
    (total) == 0 ? 0 : (self.total_good.to_f/(total))*100
  end

  def score_ok
    total = self.total_good + self.total_ok + self.total_bad
    (total) == 0 ? 0 : (self.total_ok.to_f/(total))*100
  end

  def score_bad
    total = self.total_good + self.total_ok + self.total_bad
    (total) == 0 ? 0 : (self.total_bad.to_f/(total))*100
  end

end
