# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Post < ActiveRecord::Base
  # Validations
  validates_presence_of :user_id
  validates_presence_of :post_category_id
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :school_id
  validates_presence_of :department_id

  # Relations
  belongs_to :user
  belongs_to :school
  belongs_to :department
  belongs_to :post_category
  has_one :post_assignment, :dependent => :destroy
  has_one :post_project, :dependent => :destroy
  has_one :post_education, :dependent => :destroy
  has_one :post_tutor, :dependent => :destroy
  has_one :post_book, :dependent => :destroy
  has_one :post_job, :dependent => :destroy
  has_one :post_party, :dependent => :destroy
  has_one :post_awareness, :dependent => :destroy
  has_one :post_housing, :dependent => :destroy
  has_one :post_teamup, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_one :post_qa, :dependent => :destroy

  # Attach file
  has_attached_file :attach

  # Comments
  acts_as_commentable
  
  # Tags
  acts_as_taggable
  
  # Rating
  ajaxful_rateable :stars => 5

  # Tracker
  acts_as_activity :user
  
  # Ferret
  acts_as_ferret :fields => {
    :post_category_id => {:strore => :no, :index => :untokenized},
    :title => {:strore => :yes},
    :description => {:strore => :yes}
  }, :remote => true
  
  # Named scopes
  named_scope :has_educations, :conditions => "id IN (Select post_id From post_educations)", :order => "created_at DESC"
  named_scope :has_tutors, :conditions => "id IN (Select post_id From post_tutors)", :order => "created_at DESC"
  named_scope :has_books, :conditions => "id IN (Select post_id From post_books)", :order => "created_at DESC"
  named_scope :has_jobs, :conditions => "id IN (Select post_id From post_jobs)", :order => "created_at DESC"
  named_scope :has_parties, :conditions => "id IN (Select post_id From post_parties)", :order => "created_at DESC"
  named_scope :has_awarenesses, :conditions => "id IN (Select post_id From post_awarenesses)", :order => "created_at DESC"
  named_scope :has_housings, :conditions => "id IN (Select post_id From post_housings)", :order => "created_at DESC"
  named_scope :has_teamups, :conditions => "id IN (Select post_id From post_teamups)", :order => "created_at DESC"

  def self.paginated_post_conditions_with_search(params, school)
    if params[:search]
      query = params[:search][:query]
      type = params[:search][:type]
    end
    
    cond = Caboose::EZ::Condition.new :posts do
      post_category_id == type if type
      school_id == school.id if school
    end
    
    if query
      Post.find_with_ferret(query, :conditions => cond.to_sql(), :order => "created_at DESC")
    else
      Post.find(:all, :conditions => cond.to_sql(), :order => "created_at DESC")
    end
  end

  def self.paginated_post_more_like_this(post)
    cond = Caboose::EZ::Condition.new :posts do
      type_name == post.type_name
      department_id == post.department_id
    end
    Post.find :all, :conditions => cond.to_sql(), :order => "created_at DESC"
  end
  
end
