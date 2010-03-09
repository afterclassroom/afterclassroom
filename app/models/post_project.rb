# Â© Copyright 2009 AfterClassroom.com â€” All Rights Reserved
class PostProject < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :due_date, :conditions => ["due_date > ?", Time.now], :order => "due_date DESC"
  named_scope :interesting, :conditions => ["(Select Count(*) From favorites Where favorites.post_id = post_projects.post_id) > ?", 10]
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["post_projects.id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["post_projects.id > ?", att]} }

  # Tags
  acts_as_taggable

  def self.paginated_post_conditions_with_due_date(params, school)
    posts = []
    post_as = self.with_school(school).due_date
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_conditions_with_interesting(params, school)
    posts = []
    post_as = self.with_school(school).interesting
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
