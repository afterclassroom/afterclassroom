class LearnToolsController < ApplicationController
  layout 'student_lounge'
  
  before_filter :get_variables, :only => [:index, :search_tool]
  
  def index
    @features = Learntool.paging_featured(params)
    params[:feature_page] = params[:feature_page] ? params[:feature_page]  : "1"
    @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2.0 ).round.to_s
    
    
    params[:may_like_page] = params[:may_like_page] ? params[:may_like_page]  : "1"
    @maylikes = Learntool.paging_may_like(params)
    @str_maylike_page = "Page #{params[:may_like_page]} of "+ ( Learntool.with_may_like.size / 10.0 ).round.to_s
  end
  
  def mylearn
    
  end
  
  def featured_tool_paging
    params[:feature_page] = params[:page_to_load]
    #params[:feature_page] = "3"
    @features = Learntool.paging_featured(params)
    @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2 ).round.to_s
    
    render :layout => false
  end
  
  def maylike_tool_paging
    params[:maylike_to_load] = params[:page_to_load]
    render :layout => false
  end
  
  def search_tool
    #BEGIN temporary code for developing purpose only
    @features = Learntool.paging_featured(params)
    params[:feature_page] = params[:feature_page] ? params[:feature_page]  : "1"
    @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2.0 ).round.to_s
    #END temporary code for developing purpose only


    render :template => 'learn_tools/index' 
  end
  
  private
  
  def get_variables
    @tool_cats = LearnToolCate.find(:all)
    params[:tool_cate] = params[:tool_cate] ? params[:tool_cate] : "Please select..."
  end
  
end
