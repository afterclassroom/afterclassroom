class LearnToolsController < ApplicationController
  layout 'student_lounge'
  
  def index
    @features = Learntool.paging_featured(params)
    params[:feature_page] = "1"
    @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2 ).round.to_s
    @tool_cats = LearnToolCate.find(:all)
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
end
