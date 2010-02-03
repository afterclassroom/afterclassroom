# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAwarenessesController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search, :due_date]
  before_filter :login_required, :except => [:index, :show]
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index]
  # GET /post_awarenesses
  # GET /post_awarenesses.xml
  def index
    if params[:more_like_this_id]
      post = Post.find_by_id(params[:more_like_this_id])
      @posts = PostAwareness.paginated_post_more_like_this(post).paginate :page => params[:page], :per_page => 10
    else
      if params[:search]
        @search_name = params[:search][:name]
      end

      school = session[:your_school]
      @posts = PostAwareness.paginated_post_conditions_with_search(params, school).paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @post_awarenesses }
    end
  end

  # GET /post_awarenesses/1
  # GET /post_awarenesses/1.xml
  def show
    @post_awareness = PostAwareness.find(params[:id])
    @post = @post_awareness.post
    @post_category_id = @post.post_category_id
    @type_name = @post.post_category.name
    @comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")
    update_views(@post_awareness.post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_awareness }
    end
  end

  def show_dialog
    @post = Post.find(params[:id])
    update_views(@post)
    render :layout => false
  end

  # GET /post_awarenesses/new
  # GET /post_awarenesses/new.xml
  def new
    @post_awareness = PostAwareness.new
    post = Post.new
    @post_awareness.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Student Awareness"
    @awareness_issues = AwarenessIssue.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_awareness }
    end
  end

  # GET /post_awarenesses/1/edit
  def edit
    @post_awareness = PostAwareness.find(params[:id])
    @post = @post_awareness.post
    @post_categories = PostCategory.find(:all)
    @awareness_issues = AwarenessIssue.find(:all)
    @countries = Country.has_cities
    @school = @post_awareness.post.school
    @department = @post_awareness.post.department
    @post_awareness_issue = ""
    for awareness_issue in @post_awareness.awareness_issues
      @post_awareness_issue += awareness_issue.name + ", "
    end
  end

  # POST /post_awarenesses
  # POST /post_awarenesses.xml
  def create
    @post_awareness = PostAwareness.new(params[:post_awareness])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_awareness.post = post

    if @post_awareness.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_awarenesses/1
  # PUT /post_awarenesses/1.xml
  def update
    params[:post_awareness][:awareness_issue_ids] ||= []
    @post_awareness = PostAwareness.find(params[:id])

    if (@post_awareness.update_attributes(params[:post_awareness]) && @post_awareness.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_awarenesses/1
  # DELETE /post_awarenesses/1.xml
  def destroy
    @post_awareness = PostAwareness.find(params[:id])
    @post_awareness.destroy

    redirect_to my_post_user_url(current_user)
  end

  def update_views(obj)
    updated = update_view_count(obj)
  end

  private

  def get_variables
    @new_post_path = new_post_assignment_path
    @type = PostCategory.find_by_name("Assignments").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostAwareness.find(params[:post_awareness_id] || params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
