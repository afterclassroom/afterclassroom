class Learntool < ActiveRecord::Base
  belongs_to :user
  belongs_to :learn_tool_cate
  belongs_to :client_application
  
  
  #with_featured is those tools use AfterclassroomAPI
  scope :with_featured, :conditions => "client_application_id > 0", :order => "learntools.acc_play_no DESC"
  
  #with_payable is those tools that third-party pay money to AfterClassroom
  scope :with_payable, :conditions =>  "acc_play_no > 0", :order => "learntools.acc_play_no DESC"
  
  def self.paging_featured(params)
      Learntool.with_featured.paginate(:page => params[:feature_page], :per_page => 2)
  end
  
end
