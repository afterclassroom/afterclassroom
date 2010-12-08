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
  
  # Named scope
  named_scope :with_user_id, lambda {|usr| {:conditions => ["user_id = ?", usr], :order => "created_at DESC"}}

  # Attach file
  has_attached_file :attach, {
    :bucket => 'afterclassroom_post'
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
end
