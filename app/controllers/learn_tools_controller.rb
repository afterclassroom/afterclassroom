class LearnToolsController < ApplicationController
  include LearnToolsHelper
  
  layout 'student_lounge'
  
  before_filter :get_variables, :only => [:index, :search_tool, :new_tool, :submit_new_tool, :new_tool_with_api, :create_tool_with_api]
  
  def index
    @cur_bottom_tab = "first"#by default, the first bottom-tab is selected
    if params[:tool_cate] == "-1"
      @features = Learntool.paging_featured(params)
      params[:feature_page] = params[:feature_page] ? params[:feature_page]  : "1"
      @str_feature_page = "Page #{params[:feature_page]} of "+ ( Learntool.with_featured.size / 2.0 ).round.to_s
    
      params[:may_like_page] = params[:may_like_page] ? params[:may_like_page]  : "1"
      @maylikes = Learntool.paging_may_like(params)
      
      no_maylike_page = Learntool.with_may_like.size / 10.0 
      if Learntool.with_may_like.size % 10 > 0
        no_maylike_page = no_maylike_page + 1
      end
      
      @str_maylike_page = "Page #{params[:may_like_page]} of #{no_maylike_page.to_i}"
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
    
    if params[:see_all] != nil && params[:see_all] == "See all tool"
      size = current_user.my_tools.size
      @my_tools = current_user.my_tools.paginate(:page => params[:page], :per_page => size)
    end
  end
  
  def show
    @tool = Learntool.find(params[:id])
    @tool_reviews = @tool.tool_reviews.order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
  end
  
  def tool_rev_paging
    @tool = Learntool.find(params[:tool_id])
    @tool_reviews = @tool.tool_reviews.order("created_at DESC").paginate(:page => params[:review_page_to_load], :per_page => 5)
    @cur_rev_page = params[:review_page_to_load]
    render :layout => false
  end
  
  def write_review_form
    @tool_id = params[:tool_id]
    @toolreview = ToolReview.new
    render :layout => false
  end

  def edit_review_form
    @toolreview = ToolReview.find(params[:review_id])
    render :layout => false
  end
  
  def update_review
    @toolreview = ToolReview.find(params[:review_id])
    @toolreview.update_attributes(params[:tool_review])
    @toolreview.save
    
    render :layout => false
  end
  
  def delete_review
    @toolreview = ToolReview.find(params[:review_id])
    @toolreview.destroy
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
      
      no_maylike_page = Learntool.with_may_like.size / 10.0 
      if Learntool.with_may_like.size % 10 > 0
        no_maylike_page = no_maylike_page + 1
      end
      @str_maylike_page = "Page #{params[:may_like_page]} of #{no_maylike_page.to_i}"
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
    @tool = Learntool.find(params[:tool_id])
    render :layout => false
  end
  
  def send_to_dev
    @tool = Learntool.find(params[:tool_id])
    QaSendMail.learntool_to_dev(current_user,@tool).deliver
    flash[:notice] = "Sent to developer: #{@tool.user.email}"
    render :layout => false
  end
  
  def see_all_tool_fan
    tool = Learntool.find(params[:current_tool_id])
    @obj_fans = display_fan(tool)
    render :layout => false
  end
  
  def become_a_fan
    tool = Learntool.find(params[:tool_id])
    
    fan = Fan.new
    fan.user_id = current_user.id
    tool.fans << fan

    render :text => "You are a fan"
  end
  
  def new_tool
    @tool = Learntool.new
    @video = Video.new()
    @categories ||= Youtube.video_categories
  end
  
  def submit_new_tool
    
    @tool = Learntool.new(params[:learntool])
    @tool.video_id = params[:learntool_video_id]
    
    @tool.user = current_user
    @tool.verify = false #meaning::tool has not been verified
    
    @video = Video.new(params[:video])
    @video.user = current_user
    @video.tag_list = params[:tag_list]
    
    str_notice = ""
    
    if simple_captcha_valid?
      if @tool.save
        if (params[:vid_check] == "new video upload")
          if @video.save!
            @video.convert
            @tool.video_id = @video.id
            @tool.save
            post_wall(@video)
          else
            str_notice = "Failed to add video."
          end
        end
        
        flash[:notice] = "Your tool was successfully submitted. #{str_notice}"
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
    rating = params[:rating]
    @tool = Learntool.find(params[:tool_id])
    @tool.rate rating.to_i, current_user    
    @tool.save
    
    render :layout => false
  end
  
  def new_tool_with_api
    @tool = Learntool.new
    @client_application = ClientApplication.new
  end
  
  def create_tool_with_api
    str_error = ""
    client_application = current_user.client_applications.build(params[:client_application])
    tool = Learntool.new(params[:learntool])
    tool.user = current_user
    tool.client_application = client_application
    tool.name = client_application.name
    tool.href = client_application.url
    tool.ac_api = true
    tool.verify = false #meaning::tool has not been verified
    
    
    if simple_captcha_valid?
      if client_application.save && tool.save
        @tool = Learntool.new #these 2 lines to support for form_new to display correct
        @client_application = ClientApplication.new
        
        flash[:notice] = "Your tool has been submitted"
        render :action => "new_tool_with_api"
      else
        @tool = tool#these 2 lines to support for form_new to display correct
        @client_application = client_application
        
        str_error = "Failed to create API !"
        flash[:notice] = str_error
        render :action => "new_tool_with_api"
      end
    else
      @tool = tool#these 2 lines to support for form_new to display correct
      @client_application = client_application
      flash[:warning] = "Captcha does not match."
      render :action => "new_tool_with_api"
    end
    
  end
  
  def verify_handler
    tool = Learntool.find(params[:tool_id])
    tool.verify = params[:check_status]
    tool.save
    render :text => "Done"
  end
  
  def owner_handler
    tool = Learntool.find(params[:tool_id])
    tool.atc_creator = params[:own_status]
    tool.save
    render :text => "Done == #{tool.atc_creator}, new state = #{params[:own_status]}"
  end
  
  def choose_to_add #display options API/NonAPI when user add new tool
    render :layout => false
  end
  
  def video_list
    @cur_bottom_page = 1 #this param used for ajax_paging on thickbox
    @my_videos = current_user.videos.find(:all, :conditions => ["state = ?", "converted"], :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    render :layout => false
  end
  
  def video_list_paging
    @cur_bottom_page = params[:bottom_page_to_load]
    @my_videos = current_user.videos.find(:all, :conditions => ["state = ?", "converted"], :order => "created_at DESC").paginate :page => params[:bottom_page_to_load], :per_page => 15
    render :layout => false
  end
  
  def play_vid
    @video = Video.find(params[:vid_id])
    render :layout => false
  end
  
  def toolmanager
    @my_tools = current_user.learntools.paginate(:page => params[:page], :per_page => 5)
    
    if params[:see_all] != nil && params[:see_all] == "See all tool"
      size = current_user.learntools.size
      @my_tools = current_user.learntools.paginate(:page => params[:page], :per_page => size )
    end
    
    
    size = current_user.learntools.size
  end
  
  def edit_tool
    @tool_cats = LearnToolCate.find(:all)
    @tool = Learntool.find(params[:tool_id])
    @video_name = ""
    if @tool.video_id != nil
      @video_name = Video.find(@tool.video_id).title
    end
  end
  
  def save_edit_tool
    @tool = Learntool.find(params[:tool_id])
    @tool.update_attributes(params[:learntool])
    @tool.video_id = params[:learntool_video_id]
    
    if @tool.save
      flash[:notice] = "Your tool was successfully submitted."
      redirect_to :controller=>'learn_tools', :action => 'toolmanager'
    else
      @tool_cats = LearnToolCate.find(:all)
      flash[:notice] = "Error! Possibly due to File Size too large"
      render :action => "edit_tool"
    end
  end
  
  def delete_tool
    @tool = Learntool.find(params[:tool_id])
    if @tool.destroy
      flash[:notice] = "Removed 1 tool"
    else
      flash[:notice] = "Error! Failed to remote tool"
    end
    redirect_to :controller=>'learn_tools', :action => 'toolmanager'
  end
  
  private
  
  def get_variables
    @tool_cats = LearnToolCate.find(:all)
    params[:tool_cate] = params[:tool_cate] ? params[:tool_cate] : "-1"
  end
  
end
