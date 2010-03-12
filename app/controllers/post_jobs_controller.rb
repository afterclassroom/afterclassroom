# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostJobsController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search, :tag]
  before_filter :login_required, :except => [:index, :show, :search, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :tag]
  # GET /post_jobs
  # GET /post_jobs.xml
  def index
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = Post.paginated_post_more_like_this(params, post)
    else
      @posts = Post.paginated_post_conditions_with_option(params, @school, @type)
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
    tag_id = params[:tag_id]
    @tag = Tag.find(tag_id)
    @posts = PostJob.paginated_post_conditions_with_tag(params, @school, @tag.name)
  end

  # GET /post_jobs/1
  # GET /post_jobs/1.xml
  def show
    @post = Post.find(params[:id])
    @post_qa = @post.post_qa
    update_view_count(@post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_qa }
    end
  end

  # GET /post_jobs/new
  # GET /post_jobs/new.xml
  def new
    @post_job = PostJob.new
    post = Post.new
    @post_job.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Jobs"
    @per = ['Hour', 'Session', 'Week', 'Month', 'Semester']
    @currency = ['USD', 'CAD']
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
    @per = ['Hour', 'Session', 'Week', 'Month', 'Semester']
    @currency = ['USD', 'CAD']
    @countries = Country.has_cities
    @school = @post_job.post.school
    @department = @post_job.post.department
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

  private

  def get_variables
    @tags = PostJob.tag_counts
    @new_post_path = new_post_qa_path
    @type = PostCategory.find_by_name("Jobs").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostJob.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
