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
  has_one :post_lecture_note, :dependent => :destroy
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
  scope :with_user_id, lambda {|usr| {:conditions => ["user_id = ?", usr], :order => "posts.created_at DESC"}}
  
  # Attach file
  has_attached_file :attach, {
    :bucket => 'afterclassroom_post',
    :styles => Proc.new { |a| a.instance.file_styles }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  validates_attachment_size :attach, :less_than => FILE_SIZE_POST
  
  # Comments
  acts_as_commentable
  
  # Favorite
  acts_as_favorite

	# Friendly ID
  extend FriendlyId
  friendly_id :title, :use => :slugged
  
  # Solr search index
  searchable do
    text :title, :default_boost => 2, :stored => true
    text :description, :stored => true
    integer :user_id, :references => User
    integer :post_category_id, :references => PostCategory
    integer :school_id, :references => School
    time :created_at
  end
  
  handle_asynchronously :solr_index
  
  def self.paginated_post_conditions_with_search(params, school, type)
    Post.search do
      if params[:search][:query].present?
        keywords(params[:search][:query]) do
          highlight :description
        end
      end
      if school
        with :school_id, school 
      end
      with :post_category_id, type
      order_by :created_at, :desc
      paginate :page => params[:page], :per_page => 10
    end
  end
  
  def self.paginated_post_management(params, current_user_id)
    sort = 'DESC'
    sort = params[:sort] if params[:sort]
    Post.search do
      if params[:search].present?
        keywords(params[:search][:query]) do
          highlight :description
        end
      end
      with :user_id, current_user_id
      order_by :created_at, sort.downcase.to_sym
      paginate :page => params[:page], :per_page => 10
    end
  end
  
  def self.paginated_post_management_admin(params)
    sort = 'DESC'
    sort = params[:sort] if params[:sort]
    cat_name = params[:category]
    category = PostCategory.find_by_class_name(cat_name)
    if category
      Post.search do
        if params[:search][:query].present?
          keywords(params[:search][:query]) do
            highlight :description
          end
        end
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
  
  
  def self.recent_interesting(school_id, post_type)
    
    str_school_condition = ""
    
    if school_id != nil
      str_school_condition = "where p.school_id = #{school_id}"
    end
    
    objs = Post.find_by_sql("select p.* from posts as p right join (select * from #{post_type}) as qa on p.id = qa.post_id
inner join
(select a.favorable_id, a.created_at, b.total from favorites as a
right join (
select favorable_id,count(favorable_id) as total from favorites
group by favorable_id
having count(favorable_id)>10
) as b
on a.favorable_id = b.favorable_id
order by a.favorable_id DESC, a.created_at DESC ) as f
on p.id = f.favorable_id 
#{str_school_condition}
group by f.favorable_id 
order by f.created_at DESC")
    
    
  end
  
  
  
end
