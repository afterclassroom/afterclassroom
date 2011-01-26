# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTestsController < ApplicationController
  

  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :interesting, :tag]
  before_filter :login_required, :except => [:index, :show, :search, :interesting, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :interesting, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :tag]
  # GET /post_tests
  # GET /post_tests.xml
  def index
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = PostTest.paginated_post_more_like_this(params, post)
    else
      @posts = PostTest.paginated_post_conditions_with_option(params, @school)
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

  def interesting
    @posts = PostTest.paginated_post_conditions_with_interesting(params, @school)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def tag
    tag_id = params[:tag_id]
    @tag = Tag.find(tag_id)
    @posts = PostText.paginated_post_conditions_with_tag(params, @school, @tag.name)
  end

  # GET /post_tests/1
  # GET /post_tests/1.xml
  def show
    @post = Post.find(params[:id])
    @post_test = @post.post_test
    update_view_count(@post)
    posts_as = PostTest.with_school(@school)
    as_next = posts_as.next(@post_test.id).first
    as_prev = posts_as.previous(@post_test.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_test }
    end
  end

  # GET /post_tests/new
  # GET /post_tests/new.xml
  def new
    @post_test = PostTest.new
    @post = Post.new
    @post_test.post = @post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_test }
    end
  end

  # GET /post_tests/1/edit
  def edit
  end

  # POST /post_tests
  # POST /post_tests.xml
  def create
    @post_test = PostTest.new(params[:post_test])
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post.save
    @post_test.tag_list = params[:tag]
    @post_test.post = @post
    if @post_test.save
      notice "Your post was successfully created."
      redirect_to post_tests_path
    else
      error "Failed to create a new post."
      render :action => "new"
    end
  end

  # PUT /post_tests/1
  # PUT /post_tests/1.xml
  def update
    params[:post_test][:test_type_ids] ||= []
    @post_test = PostTest.find(params[:id])

    if (@post_test.update_attributes(params[:post_test]) && @post_test.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_tests/1
  # DELETE /post_tests/1.xml
  def destroy
    @post_test = PostTest.find(params[:id])
    @post_test.destroy

    redirect_to my_post_user_url(current_user)
  end

  private

  def get_variables
    @tags = PostTest.tag_counts_on(:tags)
    @new_post_path = new_post_test_path
    @class_name = "PostTest"
    @type = PostCategory.find_by_class_name(@class_name).id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    post = Post.find(params[:id])
    @post_exam = post.post_test
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
