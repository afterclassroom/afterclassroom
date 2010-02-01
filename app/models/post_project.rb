# Â© Copyright 2009 AfterClassroom.com â€” All Rights Reserved
class PostProject < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id

  # Relations
  belongs_to :post

  # Named Scope
  named_scope :due_date, lambda {|sc| return {:conditions => ["due_date > ?", Time.now], :order => "due_date DESC"} if sc.nil?; {:joins => :post, :conditions => ["school_id = ? AND due_date > ?", sc, Time.now], :order => "due_date DESC"}}
  named_scope :with_limit, :limit => 5

  def self.paginated_post_conditions_with_due_date(params, school)
    posts = []
    post_as = self.due_date(school)
    post_as.select {|p| posts << p.post}
    posts.paginate :page => params[:page], :per_page => 10
  end
  
end
