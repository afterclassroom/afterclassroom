# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAssignmentsController < ApplicationController
  include Viewable
  
  before_filter :params_search_post, :only => [:index, :show, :edit]
  before_filter :login_required, :except => [:index, :show]
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index]
  # GET /post_jobs
  # GET /post_jobs.xml
  def index
    if params[:more_like_this_id]
      post = Post.find_by_id(params[:more_like_this_id])
      @posts = Post.paginated_post_more_like_this(post).paginate :page => params[:page], :per_page => 10
    else
      if params[:search]
        @search_name = params[:search][:name]
      end

      school = session[:your_school]
      @posts = Post.paginated_post_conditions_with_search(params, school).paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts}
    end
  end

  # GET /post_jobs/1
  # GET /post_jobs/1.xml
  def show
    @post_job = PostJob.find(params[:id])
    @post = @post_job.post
    @post_category_id = @post.post_category_id
    @type_name = @post.post_category.name
    @comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")
    update_views(@post_job.post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_job }
    end
  end

  def show_dialog
    @post = Post.find(params[:id])
    update_views(@post)
    render :layout => false
  end

  # GET /post_jobs/new
  # GET /post_jobs/new.xml
  def new
    @post_job = PostJob.new
    post = Post.new
    @post_job.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Jobs"
    @prepare_post = {'Yes' => true, 'No' => false}
    @job_types = JobType.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_job }
    end
  end

  # GET /post_jobs/1/edit
  def edit
    @post_job = PostJob.find(params[:id])
    @post = @post_job.post
    @post_categories = PostCategory.find(:all)
    @prepare_post = {'No' => false, 'Yes' => true}
    @job_types = JobType.find(:all)
    @countries = Country.has_cities
    @school = @post_job.post.school
    @department = @post_job.post.department
    @post_job_type = ""
    for job_type in @post_job.job_types
      @post_job_type += job_type.name + ", "
    end
  end

  # POST /post_jobs
  # POST /post_jobs.xml
  def create
    @post_job = PostJob.new(params[:post_job])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_job.post = post

    if @post_job.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_jobs/1
  # PUT /post_jobs/1.xml
  def update
    params[:post_job][:job_type_ids] ||= []
    @post_job = PostJob.find(params[:id])

    if (@post_job.update_attributes(params[:post_job]) && @post_job.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_jobs/1
  # DELETE /post_jobs/1.xml
  def destroy
    @post_job = PostJob.find(params[:id])
    @post_job.destroy

    redirect_to my_post_user_url(current_user)
  end

  def update_views(obj)
    updated = update_view_count(obj)
  end

  protected
  
  def params_search_post
    @search_name = params[:search][:name] if params[:search] 
    @type_search = PostCategory.find_by_name("Assignments").id
    @search_post_path = post_assignments_path
    @new_post_path = new_post_assignment_path
  end

  def require_current_user
    @user ||= PostJob.find(params[:post_job_id] || params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
