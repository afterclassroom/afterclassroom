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
  has_one :post_test, :dependent => :destroy
  has_one :post_exam, :dependent => :destroy
  has_one :post_myx, :dependent => :destroy
  has_one :post_project, :dependent => :destroy
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
  
  # ThinkSphinx
  define_index do
    indexes title, :sortable => true
    indexes description
    has post_category_id, school_id
  end
  
  def self.paginated_post_conditions_with_search(params, school, type)
    if params[:search]
      query = params[:search][:query]
     
      if school
        Post.search(query, :with => {:post_category_id => type, :school_id => school.id}, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
      else
        Post.search(query, :with => {:post_category_id => type}, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
      end
    end
  end

  def self.paginated_post_conditions_with_option(params, school, type)
    over = 30 || params[:over].to_i
    year = params[:year]
    department = params[:department]

    cond = Caboose::EZ::Condition.new :posts do
      post_category_id == type if type
      school_id == school.id if school
      school_year == year if year
      department_id == department if department
      created_at > Time.now - over.day
    end

    Post.find(:all, :conditions => cond.to_sql(), :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
  end

  def self.paginated_post_more_like_this(post)
    cond = Caboose::EZ::Condition.new :posts do
      type_name == post.type_name
      department_id == post.department_id
      school_year == post.school_year
    end
    Post.find(:all, :conditions => cond.to_sql(), :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
  end
  
end
