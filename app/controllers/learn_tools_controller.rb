class LearnToolsController < ApplicationController
  layout 'student_lounge'
  
  before_filter :get_variables, :only => [:index, :search_tool]
  
  def index
    if params[:tool_cate] == "-1"
      @features = Learntool.paging_featured(params)
      params[:feature_page] = params[:feature_page] ? params[:feature_page]  : "1"
      @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2.0 ).round.to_s
    
      params[:may_like_page] = params[:may_like_page] ? params[:may_like_page]  : "1"
      @maylikes = Learntool.paging_may_like(params)
      @str_maylike_page = "Page #{params[:may_like_page]} of "+ ( Learntool.with_may_like.size / 10.0 ).round.to_s
      
      @all_tools = Learntool.find(:all, :order => "learntools.created_at DESC").paginate(:page => params[:all_tool_page], :per_page => 5)
    else #when user filter tool by category
      #with_cate
      @features = Learntool.with_cate(params[:tool_cate]).paging_featured(params)
      @maylikes = Learntool.with_cate(params[:tool_cate]).paging_may_like(params)
      params[:feature_page] = "1"
      params[:may_like_page]= "1"
      @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_cate(params[:tool_cate]).with_featured.size / 2.0 ).round.to_s
      @str_maylike_page = "Page #{params[:may_like_page]} of "+ ( Learntool.with_cate(params[:tool_cate]).with_may_like.size / 10.0 ).round.to_s
    end
  end
  
  def mylearn
    
  end
  
  def newlearn
    
  end
  
  def featured_tool_paging
    if params[:cur_cate_at_feature] == "-1"#there is no category selected
      params[:feature_page] = params[:page_to_load]#page of will_paginate
    
      @features = Learntool.paging_featured(params)
      @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2.0 ).round.to_s
    else
      params[:feature_page] = params[:page_to_load]#page of will_paginate
    
      @features = Learntool.with_cate(params[:cur_cate_at_feature]).paging_featured(params)
      @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_cate(params[:cur_cate_at_feature]).with_featured.size / 2.0 ).round.to_s
      @cur_cate_at_feat = params[:cur_cate_at_feature]
    end
    
    render :layout => false
  end
  
  def maylike_tool_paging
    #cur_cate_at_maylike
    if params[:cur_cate_at_maylike] == "-1"
      params[:may_like_page] = params[:maylike_to_load]#page of will_paginate
      @maylikes = Learntool.paging_may_like(params)
      @str_maylike_page = "Page #{params[:may_like_page]} of "+ ( Learntool.with_may_like.size / 10.0 ).round.to_s
    else
      params[:may_like_page] = params[:maylike_to_load]#page of will_paginate
      @maylikes = Learntool.with_cate(params[:cur_cate_at_maylike]).paging_may_like(params)
      @str_maylike_page = "Page #{params[:may_like_page]} of "+ ( Learntool.with_cate(params[:cur_cate_at_maylike]).with_may_like.size / 10.0 ).round.to_s
      @cur_cate_at_like = params[:cur_cate_at_maylike]
    end
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
    params[:tool_cate] = params[:tool_cate] ? params[:tool_cate] : "-1"
  end
  
end
