# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostExamsController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :due_date, :tag]
  before_filter :login_required, :except => [:index, :show, :search, :due_date, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :due_date, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :due_date, :tag]
  # GET /post_exams
  # GET /post_exams.xml
  def index
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = PostExam.paginated_post_more_like_this(params, post)
    else
      @posts = PostExam.paginated_post_conditions_with_option(params, @school)
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
    @posts = PostExam.paginated_post_conditions_with_due_date(params, @school)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def tag
    tag_id = params[:tag_id]
    @tag = Tag.find(tag_id)
    @posts = PostExam.paginated_post_conditions_with_tag(params, @school, @tag.name)
  end
  
  # GET /post_exams/1
  # GET /post_exams/1.xml
  def show
    @post = Post.find(params[:id])
    @post_exam = @post.post_exam
    update_view_count(@post)
    posts_as = PostExam.with_school(@school)
    as_next = posts_as.next(@post_exam.id).first
    as_prev = posts_as.previous(@post_exam.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_exam }
    end
  end

  # GET /post_exams/new
  # GET /post_exams/new.xml
  def new
    @post_exam = PostExam.new
    post = Post.new
    @post_exam.post = post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_exam }
    end
  end

  # GET /post_exams/1/edit
  def edit
  end

  # POST /post_exams
  # POST /post_exams.xml
  def create
    @post_exam = PostExam.new(params[:post_exam])
    post = Post.new(params[:post])
    post.user = current_user
    post.school_id = @school
    post.post_category_id = @type
    post.type_name = @class_name
    post.save
    @post_exam.tag_list = params[:tag]
    @post_exam.post = post
    if @post_exam.save
      notice "Your post was successfully created."
      redirect_to post_exams_path
    else
      error "Failed to create a new post."
      render :action => "new"
    end
  end

  # PUT /post_exams/1
  # PUT /post_exams/1.xml
  def update
    params[:post_exam][:exam_type_ids] ||= []
    @post_exam = PostExam.find(params[:id])

    if (@post_exam.update_attributes(params[:post_exam]) && @post_exam.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_exams/1
  # DELETE /post_exams/1.xml
  def destroy
    @post_exam = PostExam.find(params[:id])
    @post_exam.destroy

    redirect_to my_post_user_url(current_user)
  end

  def update_views(obj)
    updated = update_view_count(obj)
  end

  private

  def get_variables
    @tags = PostExam.tag_counts
    @new_post_path = new_post_exam_path
    @class_name = "PostExam"
    @type = PostCategory.find_by_class_name(@class_name).id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    post = Post.find(params[:id])
    @post_exam = post.post_exam
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
