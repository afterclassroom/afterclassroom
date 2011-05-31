# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTeamupsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :tag, :good_org, :worse_org]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag, :good_org, :worse_org]
  #before_filter :login_required, :except => [:index, :show, :search, :tag, :good_org, :worse_org]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :new, :edit, :search, :tag, :good_org, :worse_org]
  cache_sweeper :post_sweeper, :only => [:create, :update, :detroy]
  
  # Cache
  caches_action :show
  
  # GET /post_teamups
  # GET /post_teamups.xml
  def index
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @teamup_category_id = post.post_teamup.teamup_category_id
      @posts = PostTeamup.paginated_post_more_like_this(params, post)
    else
      @teamup_category_id = params[:teamup_category_id]
      @teamup_category_id ||= TeamupCategory.find(:first).id
      @posts = PostTeamup.paginated_post_conditions_with_option(params, @school, @teamup_category_id)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def search
    @query = params[:search][:query] if params[:search]
    if params[:search]
      @posts = Post.paginated_post_conditions_with_search(params, @school, @type)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def tag
    @tag_name = params[:tag_name]
    @posts = PostTeamup.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  def good_org
    @posts = PostTeamup.paginated_post_conditions_with_good_org(params, @school)
  end
  
  def worse_org
    @posts = PostTeamup.paginated_post_conditions_with_worse_org(params, @school)
  end
  
  def rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    @post_tm = @post.post_teamup
    @post_tm.rate rating.to_i, current_user
    # Update rating status
    score_good = @post_tm.score_good
    score_bad = @post_tm.score_bad
    
    if score_good > score_bad
      status = "Good"
    elsif score_good == score_bad
      status = "Require Rating"
    else
      status = "Bad"
    end
    
    @post_tm.rating_status = status
    
    @post_tm.save
  end
  
  # GET /post_teamups/1
  # GET /post_teamups/1.xml
  def show
    @post_teamup = PostTeamup.find(params[:id])
    @post = @post_teamup.post
    @teamup_category_id = @post_teamup.teamup_category_id
    update_view_count(@post)
    posts_as = PostTeamup.with_school(@school).with_category(@teamup_category_id)
    as_next = posts_as.nexts(@post_teamup.id).last
    as_prev = posts_as.previous(@post_teamup.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_teamup }
    end
  end
  
  # GET /post_teamups/new
  # GET /post_teamups/new.xml
  def new
    @post_teamup = PostTeamup.new
    @post = Post.new
    @post_teamup.post = @post
    @post_teamup.teamup_category_id = TeamupCategory.first.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_teamup }
    end
  end
  
  # GET /post_teamups/1/edit
  def edit
    @post_teamup = PostTeamup.find(params[:id])
    @post = @post_teamup.post
    @tag_list = @post_teamup.tags_from(@post.school).join(", ")
  end
  
  # POST /post_teamups
  # POST /post_teamups.xml
  def create
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_teamup = PostTeamup.new(params[:post_teamup])
    @post_teamup.teamup_category_id ||= TeamupCategory.first.id
      
    if simple_captcha_valid?   
      @post.save     
      sc = School.find(@school)
      sc.tag(@post_teamup, :with => @tag_list, :on => :tags)
      @post_teamup.post = @post
      
      if @post_teamup.save
        flash[:notice] = "Your post was successfully created."
        post_wall(@post, post_teamup_path(@post_teamup))
        redirect_to post_teamups_path + "?teamup_category_id=#{@post_teamup.teamup_category_id}"
      else
        flash[:error] = "Failed to create a new post."
        render :action => "new"
      end
    else
      flash[:warning] = "Captcha does not match."
      render :action => "new"
    end
  end
  
  # PUT /post_teamups/1
  # PUT /post_teamups/1.xml
  def update
    @post_teamup = PostTeamup.find(params[:id])
    @post = @post_teamup.post
    
    if (@post_teamup.update_attributes(params[:post_teamup]) && @post_teamup.post.update_attributes(params[:post]))
      sc = School.find(@post.school.id)
      sc.tag(@post_teamup, :with => params[:tag], :on => :tags)
      redirect_to post_teamup_path(@post_teamup)
    end
  end
  
  # DELETE /post_teamups/1
  # DELETE /post_teamups/1.xml
  def destroy
    @post_teamup = PostTeamup.find(params[:id])
    @post_teamup.post.favorites.destroy_all
    @post_teamup.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_teamup_path
    @class_name = "PostTeamup"
    @type = PostCategory.find_by_class_name(@class_name).id
    @query = params[:search][:query] if params[:search]
    @departments = Department.of_school(@school)
    if !fragment_exist? :browser_by_subject
      if @school
        @tags = School.find(@school).owned_tags.where(["taggable_type = ?", @class_name])
      else
        @tags = eval(@class_name).tag_counts
      end
    end
  end
  
  def require_current_user
    post_teamup = PostTeamup.find(params[:id])
    post = post_teamup.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user))) || current_user.has_role?(:admin)
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
