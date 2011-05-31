# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostProjectsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :due_date, :interesting, :tag]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :due_date, :interesting, :tag]
  #before_filter :login_required, :except => [:index, :show, :search, :due_date, :interesting, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :new, :edit, :search, :due_date, :interesting, :tag]
  cache_sweeper :post_sweeper, :only => [:create, :update, :detroy]
  
  # Cache
  caches_action :show
  
  # GET /post_projects
  # GET /post_projects.xml
  def index
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = PostProject.paginated_post_more_like_this(params, post)
    else
      @posts = PostProject.paginated_post_conditions_with_option(params, @school)
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
  
  def due_date
    @posts = PostProject.paginated_post_conditions_with_due_date(params, @school)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def interesting
    @posts = PostProject.paginated_post_conditions_with_interesting(params, @school)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def tag
    @tag_name = params[:tag_name]
    @posts = PostProject.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  # GET /post_projects/1
  # GET /post_projects/1.xml
  def show
    @post_project = PostProject.find(params[:id])
    @post = @post_project.post
    update_view_count(@post)
    posts_as = PostProject.with_school(@school)
    as_next = posts_as.nexts(@post_project.id).last
    as_prev = posts_as.previous(@post_project.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_project }
    end
  end
  
  # GET /post_projects/new
  # GET /post_projects/new.xml
  def new
    @post_project = PostProject.new
    @post = Post.new
    @post_project.post = @post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_project }
    end
  end
  
  # GET /post_projects/1/edit
  def edit
    @post_project = PostProject.find(params[:id])
    @post = @post_project.post
    @tag_list = @post_project.tags_from(@post.school).join(", ")
  end
  
  # POST /post_projects
  # POST /post_projects.xml
  def create
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_project = PostProject.new(params[:post_project])
    @post_project.due_date = DateTime.strptime(params[:due_date], "%m/%d/%Y") if params[:due_date] != ""
      
    if simple_captcha_valid? 
      @post.save
      sc = School.find(@school)
      sc.tag(@post_project, :with => @tag_list, :on => :tags)
      @post_project.post = @post
      if @post_project.save
        flash[:notice] = "Your post was successfully created."
        post_wall(@post, post_project_path(@post_project))
        redirect_to post_projects_path
      else
        flash[:error] = "Failed to create a new post."
        render :action => "new"
      end
    else
      flash[:warning] = "Captcha does not match."
      render :action => "new"
    end
  end
  
  # PUT /post_projects/1
  # PUT /post_projects/1.xml
  def update
    @post_project = PostProject.find(params[:id])
    @post = @post_project.post
    
    if (@post_project.update_attributes(params[:post_project]) && @post_project.post.update_attributes(params[:post]))
      @post_project.due_date = DateTime.strptime(params[:due_date], "%m/%d/%Y") if params[:due_date] != ""
      sc = School.find(@post.school.id)
      sc.tag(@post_project, :with => params[:tag], :on => :tags)
      @post_project.save
      redirect_to post_project_url(@post_project)
    end
  end
  
  # DELETE /post_projects/1
  # DELETE /post_projects/1.xml
  def destroy
    @post_project = PostProject.find(params[:id])
    @post_project.post.favorites.destroy_all
    @post_project.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  def quick_post_form
    @class_name = "PostProject"
    render :partial => "form_request_project"
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_project_path
    @class_name = "PostProject"
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
    post_project = PostProject.find(params[:id])
    post = post_project.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user))) || current_user.has_role?(:admin)
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
