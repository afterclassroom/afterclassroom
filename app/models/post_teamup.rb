# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTeamup < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :teamup_category_id

  # Relations
  belongs_to :post
  belongs_to :teamup_category
  belongs_to :functional_experience

  # Tags
  acts_as_taggable

  # Rating for Good or Bad
  acts_as_rated :rating_range => 0..1, :with_stats_table => true

  named_scope :with_limit, :limit => 5
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :team_startup, lambda {|c| { :order => "founded_in DESC"}}
  named_scope :more_startup, lambda {|c| { :order => "founded_in DESC"}}
  named_scope :team_filter, lambda {|c| return {} if c.nil?; {:conditions => ["teamupType = ?", c]}}
  #true: teamup for Sport, false: teamup for club
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["id > ?", att]} }

  def self.related_posts(school)
    posts = []
    post_as = self.with_school(school).random(5)
    post_as.select {|p| posts << p.post}
    posts
  end

  def self.paginated_post_conditions_with_sport(params, school)
    posts = []
    post_as = self.team_filter(true).with_school(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_club(params, school)
    posts = []
    post_as = self.team_filter(false).with_school(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_juststartup(params, school)
    posts = []
    post_as = self.more_startup(false).with_school(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
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
