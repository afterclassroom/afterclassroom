class LearnToolsController < ApplicationController
  layout 'student_lounge'
  
  def index
    @features = Learntool.paging_featured(params)
    @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2 ).round.to_s
  end
  
  def mylearn
    
  end
  
  def featured_tool_paging
    #params[:feature_page] = params[:current_page]
    params[:feature_page] = "1"
    @features = Learntool.paging_featured(params)
    @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2 ).round.to_s
    render :layout => false
  end
end
