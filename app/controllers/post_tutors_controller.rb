# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTutorsController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search]
  before_filter :login_required, :except => [:index, :show, :search]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search]
  # GET /post_tutors
  # GET /post_tutors.xml
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

  # GET /post_tutors/1
  # GET /post_tutors/1.xml
  def show
    @post = Post.find(params[:id])
    @post_qa = @post.post_qa
    update_view_count(@post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_qa }
    end
  end

  # GET /post_tutors/new
  # GET /post_tutors/new.xml
  def new
    @post_tutor = PostTutor.new
    post = Post.new
    @post_tutor.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Tutors"
    @per = ['Hour', 'Session', 'Week', 'Month', 'Semester']
    @currency = ['USD', 'CAD']
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_tutor }
    end
  end

  # GET /post_tutors/1/edit
  def edit
    @post_tutor = PostTutor.find(params[:id])
    @post = @post_tutor.post
    @post_categories = PostCategory.find(:all)
    @per = ['Hour', 'Session', 'Week', 'Month', 'Semester']
    @currency = ['USD', 'CAD']
    @countries = Country.has_cities
    @school = @post_tutor.post.school
    @department = @post_tutor.post.department
  end

  # POST /post_tutors
  # POST /post_tutors.xml
  def create
    @post_tutor = PostTutor.new(params[:post_tutor])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_tutor.post = post
    
    if @post_tutor.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_tutors/1
  # PUT /post_tutors/1.xml
  def update
    @post_tutor = PostTutor.find(params[:id])

    if (@post_tutor.update_attributes(params[:post_tutor]) && @post_tutor.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end

  end

  # DELETE /post_tutors/1
  # DELETE /post_tutors/1.xml
  def destroy
    @post_tutor = PostTutor.find(params[:id])
    @post_tutor.destroy

    redirect_to my_post_user_url(current_user)
  end

  def update_views(obj)
    updated = update_view_count(obj)
  end

  private

  def get_variables
    @tags = PostTutor.tag_counts
    @new_post_path = new_post_qa_path
    @type = PostCategory.find_by_name("Tutors").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostTutor.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
