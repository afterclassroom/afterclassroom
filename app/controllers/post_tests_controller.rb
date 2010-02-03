# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTestsController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search, :due_date]
  before_filter :login_required, :except => [:index, :show, :search, :due_date]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :due_date]
  # GET /post_tests
  # GET /post_tests.xml
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

  def due_date
    @posts = PostTest.paginated_post_conditions_with_due_date(params, @school)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /post_tests/1
  # GET /post_tests/1.xml
  def show
    @post = Post.find(params[:id])
    @post_test = @post.post_test
    update_view_count(@post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_test }
    end
  end

  # GET /post_tests/new
  # GET /post_tests/new.xml
  def new
    @post_test = PostTest.new
    post = Post.new
    @post_test.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "tests"
    @prepare_post = {'Yes' => true, 'No' => false}
    @test_types = testType.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_test }
    end
  end

  # GET /post_tests/1/edit
  def edit
    @post_test = PostTest.find(params[:id])
    @post = @post_test.post
    @post_categories = PostCategory.find(:all)
    @prepare_post = {'No' => false, 'Yes' => true}
    @test_types = testType.find(:all)
    @countries = Country.has_cities
    @school = @post_test.post.school
    @department = @post_test.post.department
    @post_test_type = ""
    for test_type in @post_test.test_types
      @post_test_type += test_type.name + ", "
    end
  end

  # POST /post_tests
  # POST /post_tests.xml
  def create
    @post_test = PostTest.new(params[:post_test])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_test.post = post

    if @post_test.save
      redirect_to my_post_user_url(current_user)
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
    @new_post_path = new_post_test_path
    @type = PostCategory.find_by_name("Tests").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostTest.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
