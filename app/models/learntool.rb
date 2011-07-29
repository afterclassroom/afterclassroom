class Learntool < ActiveRecord::Base
  belongs_to :user
  belongs_to :learn_tool_cate
  belongs_to :client_application

  has_many :my_tools, :dependent => :destroy
  has_many :players, :class_name=>"User", :through => :my_tools

  
  
  #with_featured is those tools use AfterclassroomAPI
  scope :with_featured, :conditions => "client_application_id > 0", :order => "learntools.acc_play_no DESC"
  
  #with_payable is those tools that third-party pay money to AfterClassroom
  scope :with_may_like, :conditions =>  "acc_play_no > 0", :order => "learntools.acc_play_no DESC"
  
  scope :with_cate, lambda {|cate_id| {:conditions => ["learn_tool_cate_id = ?", cate_id]}}
  
  def self.paging_featured(params)
      Learntool.with_featured.paginate(:page => params[:feature_page], :per_page => 2)
  end
  
  def self.paging_may_like(params)
      Learntool.with_may_like.paginate(:page => params[:may_like_page], :per_page => 10)
  end

end
