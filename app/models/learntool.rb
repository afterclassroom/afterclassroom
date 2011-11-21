class Learntool < ActiveRecord::Base
  belongs_to :user
  belongs_to :learn_tool_cate
  belongs_to :client_application

  has_many :my_tools, :dependent => :destroy
  has_many :tool_reviews, :dependent => :destroy
  has_one :video
  
  # Attach
  has_attached_file :tool_img, {
    :bucket => 'afterclassroom_photos',
    :styles => { :medium => "161x119>", :thumb => "90x66>", :small => "45x45#" }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  validates_attachment_presence :tool_img
  
  validates_attachment_size :tool_img, :less_than => FILE_SIZE_PHOTO
  
  validates_attachment_content_type :tool_img, :content_type => ['image/pjpeg', 'image/jpeg', 'image/gif', 'image/png', 'image/x-png']
  
  #1..5 represent for 5 stars
  #with_stats_table=true to limit user to rate for 1 time only
  acts_as_rated :rating_range => 1..5#, :with_stats_table => true
  
  acts_as_fannable

  # Solr search index
  searchable do
    text :name, :default_boost => 2, :stored => true
    text :description, :stored => true
    integer :user_id, :references => User
    time :created_at
  end
  
  handle_asynchronously :solr_index  
  
  #with_featured is those tools use AfterclassroomAPI
  scope :with_featured, :conditions => "atc_creator = true", :order => "learntools.acc_play_no DESC"
  
  #with_payable is those tools that third-party pay money to AfterClassroom
  scope :with_may_like, :order => "learntools.acc_play_no DESC"
  #Below is the correct statment, but because we do not have payment function
  #for now, so that we use the above statement instead
  #scope :with_may_like, :conditions =>  "acc_play_no > 0", :order => "learntools.acc_play_no DESC"
  
  scope :with_cate, lambda {|cate_id| {:conditions => ["learn_tool_cate_id = ?", cate_id]}}
  
  scope :with_verify, :conditions => "verify != false"
  
  scope :with_recently, :conditions => "verify != true"
  
  def self.paging_featured(params)
    Learntool.with_featured.paginate(:page => params[:feature_page], :per_page => 2)
  end
  
  def self.paging_may_like(params)
    Learntool.find(:all).paginate(:page => params[:may_like_page], :per_page => 10)
    #below is the correct statement
    #But for now, we do not have payment functionality to work for now
    #so that, we have to use the above statement
    #Learntool.with_may_like.paginate(:page => params[:may_like_page], :per_page => 10)
  end
  
  def self.most_popular(cate_id)
    if cate_id == "-1"
      objs = Learntool.find_by_sql("select * from learntools right join
(select learntool_id, count(learntool_id) as total from my_tools group by learntool_id order by total DESC) as a
on learntools.id = a.learntool_id")
    else
      objs = Learntool.find_by_sql("select * from learntools right join
(select learntool_id, count(learntool_id) as total from my_tools group by learntool_id order by total DESC) as a
on learntools.id = a.learntool_id where learn_tool_cate_id=#{cate_id}")
    end
  end

  def self.paginated_learn_tool_with_search(params)
    if params[:search_content]
      query = params[:search_content]

      Learntool.search do

        keywords(params[:search_content]) do
          highlight :description
        end

        order_by :created_at, :desc
        paginate :page =>  params[:page], :per_page => 10
      end
    end
  end
  
  def rate_result
    if self.ratings.count > 0
      x1 = self.ratings.count(:conditions => ["rating = ?", 1])
      x2 = self.ratings.count(:conditions => ["rating = ?", 2])
      x3 = self.ratings.count(:conditions => ["rating = ?", 3])
      x4 = self.ratings.count(:conditions => ["rating = ?", 4])
      x5 = self.ratings.count(:conditions => ["rating = ?", 5])
      count_no_of_rated = x1+x2+x3+x4+x5 #number of user has perform rated on this tool
      value_of_rated = x1 + x2*2 + x3*3 + x4*4 + x5*5 #sum of result that user has rated
      percent = (value_of_rated  * 100) / (5*count_no_of_rated) 
    end
  end
  
  def self.tool_api(user)
    Learntool.ez_find(:all, :order => "created_at DESC") do |t|
      t.user_id == user.id
      t.ac_api == true
    end    
  end
  
  def self.tool_no_api(user)
    Learntool.ez_find(:all, :order => "created_at DESC") do |t|
      t.user_id == user.id
      t.ac_api == false
    end    
  end  
  
  
end
