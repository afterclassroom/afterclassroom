# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Post < ActiveRecord::Base
  # Validations
  validates_presence_of :user_id
  validates_presence_of :post_category_id
  validates_presence_of :school_id
  validates_presence_of :title
  validates_presence_of :description
  
  # Relations
  belongs_to :user
  belongs_to :school
  belongs_to :department
  belongs_to :post_category
  has_one :post_assignment, :dependent => :destroy
  has_one :post_project, :dependent => :destroy
  has_one :post_test, :dependent => :destroy
  has_one :post_exam, :dependent => :destroy
  has_one :post_myx, :dependent => :destroy
  has_one :post_tutor, :dependent => :destroy
  has_one :post_book, :dependent => :destroy
  has_one :post_job, :dependent => :destroy
  has_one :post_party, :dependent => :destroy
  has_one :post_awareness, :dependent => :destroy
  has_one :post_housing, :dependent => :destroy
  has_one :post_teamup, :dependent => :destroy
  has_one :post_qa, :dependent => :destroy
  has_one :post_food, :dependent => :destroy
  has_one :post_exam_schedule, :dependent => :destroy
  has_one :post_event, :dependent => :destroy
  
  # Named scope
  scope :with_user_id, lambda {|usr| {:conditions => ["user_id = ?", usr], :order => "created_at DESC"}}
  
  # Attach file
  has_attached_file :attach, {
    :bucket => 'afterclassroom_post',
    :styles => Proc.new { |a| a.instance.file_styles }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  # Comments
  acts_as_commentable
  
  # Favorite
  acts_as_favorite
  
  # ThinkSphinx
  define_index do
    indexes title, :sortable => true
    indexes description
    has user_id, post_category_id, school_id, created_at
    set_property :delta => :delayed
  end
  
  def self.paginated_post_conditions_with_search(params, school, type)
    if params[:search]
      query = params[:search][:query]
      if school
        Post.search(query, :match_mode => :any, :with => {:post_category_id => type, :school_id => school}, :order => "created_at DESC", :page => params[:page], :per_page => 10)
      else
        Post.search(query, :match_mode => :any, :with => {:post_category_id => type}, :order => "created_at DESC", :page => params[:page], :per_page => 10)
      end
    end
  end
  
  def self.paginated_post_management(params, current_user_id)
    sort = 'DESC'
    if params[:sort]
      sort = params[:sort]
    end
    Post.search(:match_mode => :any, :with => {:user_id => current_user_id}, :order => "created_at "+sort, :page => params[:page], :per_page => 10)
  end

  def self.paginated_post_management_admin(params)
    sort = 'DESC'
    if params[:sort]
      sort = params[:sort]
    end
    cat_name = params[:category]
    category = PostCategory.find_by_class_name(cat_name)
    if category
      Post.search(:match_mode => :any, :with => {:post_category_id => category.id}, :order => "created_at "+sort, :page => params[:page], :per_page => 10)
    else
      Post.search(:match_mode => :any, :order => "created_at "+sort, :page => params[:page], :per_page => 10)
    end
  end
  
  def file_styles
    { :medium => "555x417>", :thumb => "61x51#" }
  end
  
  before_post_process :image?
  def image?
    !(attach.content_type =~ /^image.*/).nil?
  end
end
