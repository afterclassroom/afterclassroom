class LearnToolsController < ApplicationController
  include LearnToolsHelper
  
  layout 'student_lounge'
  
  before_filter :get_variables, :only => [:index, :search_tool, :new_tool, :submit_new_tool]
  
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
      @features = Learntool.with_cate(params[:tool_cate]).paging_featured(params)
      @maylikes = Learntool.with_cate(params[:tool_cate]).paging_may_like(params)
      params[:feature_page] = "1"
      params[:may_like_page]= "1"
      @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_cate(params[:tool_cate]).with_featured.size / 2.0 ).round.to_s
      @str_maylike_page = "Page #{params[:may_like_page]} of "+ ( Learntool.with_cate(params[:tool_cate]).with_may_like.size / 10.0 ).round.to_s
      @all_tools = Learntool.with_cate(params[:tool_cate]).find(:all, :order => "learntools.created_at DESC").paginate(:page => params[:all_tool_page], :per_page => 5)
    end
  end
  
  def mylearn
    @my_tools = current_user.my_tools.paginate(:page => params[:page], :per_page => 5)
  end
  
  def show
    @tool = Learntool.find(params[:id])
    @tool_reviews = @tool.tool_reviews.paginate(:page => params[:page], :per_page => 5)
  end
  
  def tool_rev_paging
    @tool = Learntool.find(params[:tool_id])
    @tool_reviews = @tool.tool_reviews.paginate(:page => params[:review_page_to_load], :per_page => 5)
    @cur_rev_page = params[:review_page_to_load]
    render :layout => false
  end
  
  def write_review_form
    @tool_id = params[:tool_id]
    @toolreview = ToolReview.new
    render :layout => false
  end
  
  def submit_review
    @toolreview = ToolReview.new(params[:tool_review])
    @tool = Learntool.find(params[:tool_id])
    @toolreview.learntool = @tool
    @toolreview.user = current_user
    
    if @toolreview.save
      flash[:notice] = "Your review was successfully created."
    end
    render :layout => false
  end
  
  def add_favorite
    #this action is applied for page My Learning Tool
    #hence, we do not need to check whether this id of MyTool exist or NOT
    mt = MyTool.find(:first, :conditions => { :id => params[:str_mytool_id], :user_id => current_user.id })
    
    mt.favorite = true
    mt.save
    render :text => "Add Complete"
  end
  
  def add_favorite_with_check
    #this one differ from above
    #we need to check whether myleartool for this current user has contained
    #this tool or not, if yes then add favorite=true, if not, then create and
    #add favorite = true
    #
    mtobj = MyTool.find(:first, :conditions => { :learntool_id => params[:current_tool_id], :user_id => current_user.id })
    tool = Learntool.find(params[:current_tool_id])
    
    if mtobj != nil
      mtobj.favorite = true
    else
      mtobj = MyTool.new
      mtobj.user = current_user
      mtobj.learntool =  tool
      mtobj.favorite = true
    end
    
    mtobj.save
    
    render :text => "Add Complete"
  end
  
  def update_play_demo
    mtobj = current_user.my_tools.where("learntool_id = ?", params[:current_tool_id]).first
    if mtobj != nil
      mtobj.play_demo = true
    else
      mtobj = MyTool.new
      mtobj.user = current_user
      mtobj.learntool =  tool
      mtobj.play_demo = true
    end
    
    mtobj.save
    
    render :text => "Update Status Complete"
  end
  
  def featured_tool_paging
    if params[:cur_cate_at_feature] == "-1"#there is no category selected
      params[:feature_page] = params[:page_to_load]#page of will_paginate
      @features = Learntool.paging_featured(params)
      @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2.0 ).round.to_s
      @cur_cate_at_feat = params[:cur_cate_at_feature]
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
      @cur_cate_at_like = params[:cur_cate_at_maylike]
    else
      params[:may_like_page] = params[:maylike_to_load]#page of will_paginate
      @maylikes = Learntool.with_cate(params[:cur_cate_at_maylike]).paging_may_like(params)
      @str_maylike_page = "Page #{params[:may_like_page]} of "+ ( Learntool.with_cate(params[:cur_cate_at_maylike]).with_may_like.size / 10.0 ).round.to_s
      @cur_cate_at_like = params[:cur_cate_at_maylike]
    end
    render :layout => false
  end
  
  def search_tool
    @str_search_val = params[:search_content]
    @obj_result = Learntool.paginated_learn_tool_with_search(params)
  end
  
  def first_tab_paging
    #bay gio cai phan nay Learntool.with_cate(params[:bottom_cur_cate])
    @cur_cate_at_bottom = params[:bottom_cur_cate]
    
    case params[:bottom_page_tab_parm]
    when "first"#all tool
      @cur_bottom_page = params[:bottom_page_to_load]
      @cur_bottom_tab = "first"
      if params[:bottom_cur_cate] != "-1" #this condition support for filter tool after selected CATEGORY
        @all_tools = Learntool.with_cate(params[:bottom_cur_cate]).find(:all, :order => "learntools.created_at DESC").paginate(:page => params[:bottom_page_to_load], :per_page => 5)
      else
        @all_tools = Learntool.find(:all, :order => "learntools.created_at DESC").paginate(:page => params[:bottom_page_to_load], :per_page => 5)
      end
    when "second" #most popular tool
      @cur_bottom_page = params[:bottom_page_to_load]
      @cur_bottom_tab = "second"
      if params[:bottom_cur_cate] != "-1" #this condition support for filter tool after selected CATEGORY
        @all_tools = Learntool.most_popular(params[:bottom_cur_cate]).paginate(:page => params[:bottom_page_to_load], :per_page => 5)
      else
        @all_tools = Learntool.most_popular("-1").paginate(:page => params[:bottom_page_to_load], :per_page => 5)
      end
    when "third" #verified tools
      @cur_bottom_page = params[:bottom_page_to_load]
      @cur_bottom_tab = "third"
      if params[:bottom_cur_cate] != "-1" #this condition support for filter tool after selected CATEGORY
        @all_tools = Learntool.with_cate(params[:bottom_cur_cate]).with_verify.paginate(:page => params[:bottom_page_to_load], :per_page => 5)
      else
        @all_tools = Learntool.with_verify.paginate(:page => params[:bottom_page_to_load], :per_page => 5)
      end
    else #fourth
      @cur_bottom_page = params[:bottom_page_to_load]
      @cur_bottom_tab = "fourth"
      if params[:bottom_cur_cate] != "-1" #this condition support for filter tool after selected CATEGORY
        @all_tools = Learntool.with_cate(params[:bottom_cur_cate]).with_recently.paginate(:page => params[:bottom_page_to_load], :per_page => 5)
      else
        @all_tools = Learntool.with_recently.paginate(:page => params[:bottom_page_to_load], :per_page => 5)
      end
    end
    render :layout => false
  end
  
  def contact_dev_form
    render :layout => false
  end
  
  def report_app_form
    render :layout => false
  end
  
  
  def see_all_tool_fan
    tool = Learntool.find(params[:current_tool_id])
    @obj_fans = display_fan(tool)
    render :layout => false
  end
  
  def new_tool
    @tool = Learntool.new
  end
  
  def submit_new_tool
    @tool = Learntool.new(params[:learntool])
    @tool.user = current_user
    if simple_captcha_valid?
      if @tool.save!
        flash[:notice] = "Your tool was successfully submitted."
        redirect_to :controller=>'learn_tools', :action => 'new_tool'
      else
        flash[:notice] = "Error !"
        render :action => "new_tool"
      end
    else
      flash[:warning] = "Captcha does not match."
      render :action => "new_tool"
    end
  end
  
  def rate
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    puts "==="
    render :layout => false
  end
  
  
  private
  
  def get_variables
    @tool_cats = LearnToolCate.find(:all)
    params[:tool_cate] = params[:tool_cate] ? params[:tool_cate] : "-1"
  end
  
end
