# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostMyxesController < ApplicationController
  include Viewable

  before_filter :params_search_post, :only => [:index, :show, :edit]
  before_filter :login_required, :except => [:index, :show, :profrating, :more_worse]
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index]


  # GET /post_myxes
  # GET /post_myxes.xml
  def index
    @list_years = [["Chose year", ""], ["1st Year", "1year"], ["2nd Year", "2year"], ["3rd Year", "3year"], ["4th Year", "4year"], ["Ms.C", "ms.c"], ["Ph.D", "ph.d"]]
    @list_overs = [["Over 30 days", "30"], ["Over 3 months", "90"], ["Over 6 months", "180"], ["Over 9 months", "270"], ["Over 1 year", "365"]]
    @year = params[:year] if params[:year] 
    @over = params[:over] if params[:over] 
    if params[:more_like_this_id]
      post = Post.find_by_id(params[:more_like_this_id])
      @posts = PostMyx.paginated_post_more_like_this(post)
    else
      school = session[:your_school]
      @posts = PostMyx.paginated_post_conditions_with_search(params, school)
    end
    #@goodprof = PostMyx.all
    @badprof = PostMyx.find_by_prof_status("Good")
    @badprof = PostMyx.find_by_prof_status("Bad")
    #@comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def show_dialog
    @post = Post.find(params[:id])
    update_views(@post)
    render :layout => false
  end

  def more_worse
    @post = PostMyx.paginated_post_conditions_with_more_worse(params)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def more_good
    @post = PostMyx.paginated_post_conditions_with_more_worse(params)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def profrating
    @post_myx = PostMyx.find(params[:id])
    if params[:rateType] == "Good"
      @post_myx.good = @post_myx.good+1
      @post_myx.update_attribute("good", @post_myx.good)
    elsif params[:rateType] == "Worse"
      @post_myx.bad = @post_myx.bad + 1
      @post_myx.update_attribute("bad", @post_myx.bad)
    else
      @post_myx.bored = @post_myx.bored + 1
      @post_myx.update_attribute("bored", @post_myx.bored)
    end

    score = (@post_myx.good.to_f / (@post_myx.good.to_f + @post_myx.bored.to_f + @post_myx.bad.to_f)) * 100
    if score > 50
      @post_myx.prof_status = "Good"
      @post_myx.update_attribute("prof_status", @post_myx.prof_status)
    else
      @post_myx.prof_status = "Worse"
      @post_myx.update_attribute("prof_status", @post_myx.prof_status)
    end


    @post_myx
  end

  # GET /post_myxes/1
  # GET /post_myxes/1.xml
  def show
    @post_myx = PostMyx.find(params[:id])
    @post = @post_myx.post
    @post_category_id = @post.post_category_id
    @type_name = @post.post_category.name
    @comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")
    update_views(@post_myx.post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_myx }
    end
  end

  






  private
  
  def params_search_post
    @query = params[:search][:query] if params[:search] 
    @type = PostCategory.find_by_name("Myx").id
    @search_post_path = post_assignments_path
    @new_post_path = new_post_assignment_path
  end
  def require_current_user
    @user ||= PostAssignment.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end


end
