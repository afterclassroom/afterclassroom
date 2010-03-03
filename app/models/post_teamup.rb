# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTeamup < ActiveRecord::Base
  # Validations
  validates_presence_of :post_id
  validates_presence_of :teamup_category_id

  # Relations
  belongs_to :post
  belongs_to :teamup_category
  belongs_to :functional_experience

  named_scope :with_limit, :limit => 5
  named_scope :recent, {:joins => :post, :order => "created_at DESC"}
  named_scope :team_startup, lambda {|c| { :order => "founded_in DESC"}}
  named_scope :more_startup, lambda {|c| { :order => "founded_in DESC"}}
  named_scope :team_filter, lambda {|c| return {} if c.nil?; {:conditions => ["teamupType = ?", c]}}
  #true: teamup for Sport, false: teamup for club
  named_scope :random, lambda { |random| {:order => "RAND()", :limit => random }}
  named_scope :previous, lambda { |att| {:conditions => ["id < ?", att]} }
  named_scope :next, lambda { |att| {:conditions => ["id > ?", att]} }

  # Tags
  acts_as_taggable

#  def self.paginated_post_conditions_with_search(params, school)
#    if params[:search]
#      search_name = params[:search][:name]
#    end
#
#    cond = Caboose::EZ::Condition.new :posts do
#      any{title =~ "%#{search_name}%"; description =~ "%#{search_name}%"} if search_name
#      school_id == school.id if school
#    end
#    cond << "id IN (Select post_id From post_teamups)"
#    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
#  end
#
#  def self.paginated_post_more_like_this(post)
#    cond = Caboose::EZ::Condition.new :posts do
#      department_id == post.department_id
#    end
#    cond << "id IN (Select post_id From post_teamups)"
#    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
#  end

  def self.related_posts(school)
    posts = []
    post_as = self.with_school(school).random(5)
    post_as.select {|p| posts << p.post}
    posts
  end
end
