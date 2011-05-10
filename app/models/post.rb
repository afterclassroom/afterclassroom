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
  
<<<<<<< HEAD

  # ThinkSphinx
  define_index do
    indexes title, :sortable => true
    indexes description
    has user_id, post_category_id, school_id, created_at
    set_property :delta => :delayed
    #set_property :delta => true

=======
>>>>>>> 6c4b9039ad362d1f5431d0572431ab4008a46005
  # Solr search index
  searchable do
    text :title, :default_boost => 2, :stored => true
    text :description, :stored => true
    integer :user_id, :references => User
    integer :post_category_id, :references => PostCategory
    integer :school_id, :references => School
    time :created_at
<<<<<<< HEAD

=======
>>>>>>> 6c4b9039ad362d1f5431d0572431ab4008a46005
  end
  
  def self.paginated_post_conditions_with_search(params, school, type)
    if params[:search]
      query = params[:search][:query]
      if school
        Post.search do
          fulltext query
          with :post_category_id, type
          with :school_id, school
          order_by :created_at, :desc
          paginate :page => params[:page], :per_page => 10
        end
      else
        Post.search do
          fulltext query
          with :post_category_id, type
          order_by :created_at, :desc
          paginate :page => params[:page], :per_page => 10
        end
      end
    end
  end
  
  def self.paginated_post_management(params, current_user_id)
    sort = 'DESC'
    sort = params[:sort] if params[:sort]
    query = params[:search][:query] if params[:search]
    Post.search do
      fulltext query
      with :user_id, current_user_id
      order_by :created_at, sort.downcase.to_sym
      paginate :page => params[:page], :per_page => 10
    end
  end
  
  def self.paginated_post_management_admin(params)
    sort = 'DESC'
    sort = params[:sort] if params[:sort]
    query = params[:search][:query]
    cat_name = params[:category]
    category = PostCategory.find_by_class_name(cat_name)
    if category
      Post.search do
        fulltext query
        with :post_category_id, category.id
        order_by :created_at, sort.downcase.to_sym
        paginate :page => params[:page], :per_page => 10
      end
    else
      Post.search do
        fulltext query
        order_by :created_at, sort.downcase.to_sym
        paginate :page => params[:page], :per_page => 10
      end
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
end
