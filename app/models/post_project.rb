# Â© Copyright 2009 AfterClassroom.com â€” All Rights Reserved
class PostProject < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post

  # Named Scope
  named_scope :with_limit, :limit => 5
  named_scope :with_school, lambda {|sc| return {} if sc.nil?; {:joins => :post, :conditions => ["school_id = ?", sc]}}
  named_scope :due_date, :conditions => ["due_date > ?", Time.now], :order => "due_date DESC"
  named_scope :interesting, :conditions => ["(Select Count(*) From favorites Where post_id = id) > ?", 10]

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
  
end
