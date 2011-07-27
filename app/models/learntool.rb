class Learntool < ActiveRecord::Base
  belongs_to :user
  belongs_to :learn_tool_cate
  
  
  scope :with_featured, :conditions => "acc_play_no > 0", :order => "learntools.acc_play_no DESC"
  
  def self.paging_featured(params)
      Learntool.with_featured.paginate(:page => params[:page], :per_page => 2)
  end
  
end
