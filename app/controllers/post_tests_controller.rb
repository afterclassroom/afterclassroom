# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostTestsController < ApplicationController
  #before_filter RubyCAS::Filter::GatewayFilter
  #before_filter RubyCAS::Filter, :except => [:index, :show, :search, :interesting, :tag, :quick_post_form]
  #before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :interesting, :tag, :quick_post_form]
  before_filter :login_required, :except => [:index, :show, :search, :interesting, :tag, :quick_post_form]
  #before_filter :login_required, :except => [:index, :show, :search, :interesting, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :new, :edit, :search, :interesting, :tag]
  cache_sweeper :post_sweeper, :only => [:create, :update, :detroy]
  
  # GET /post_tests
  # GET /post_tests.xml
  def index
    @post_results = if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @str_department = post.department_id
      @str_year = post.school_year

      Rails.cache.fetch("more_like_this_department#{post.department_id}_school_year#{post.school_year}") do
        PostTest.paginated_post_more_like_this(params, post)
      end
    else
      Rails.cache.fetch("index_#{@class_name}_#{@school}_year#{params[:year]}_department#{params[:department]}_over#{params[:over]}") do
        PostTest.paginated_post_conditions_with_option(params, @school)
      end
    end
    @posts = @post_results.paginate({:page => params[:page], :per_page => 10})
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
    #@post_results = PostTest.paginated_post_conditions_with_interesting(params, @school)
    @post_results = PostTest.recent_interesting(@school)
    @posts = @post_results.paginate({:page => params[:page], :per_page => 10})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def tag
    @tag_name = params[:tag_name]
    @posts = PostTest.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  # GET /post_tests/1
  # GET /post_tests/1.xml
  def show
    @post_test = PostTest.find(params[:id])
    @post = @post_test.post
    update_view_count(@post)
    posts_as = PostTest.with_school(@school)
    as_next = posts_as.nexts(@post_test.id).last
    as_prev = posts_as.previous(@post_test.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
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
    @post_test = PostTest.find(params[:id])
    @post = @post_test.post
    @tag_list = @post_test.tags_from(@post.school).join(", ")
  end
  
  # POST /post_tests
  # POST /post_tests.xml
  def create
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_test = PostTest.new(params[:post_test])
    if @school.nil?
			flash[:error] = "Please select school."
		  render :action => "new"
		else
		  if simple_captcha_valid?
		    @post.save  
		    sc = School.find(@school)
		    sc.tag(@post_test, :with => @tag_list, :on => :tags)
		    @post_test.post = @post
		    if @post_test.save
		      flash[:notice] = "Your post was successfully created."
		      post_wall(@post_test)
		      redirect_to post_test_url(@post_test)
		    else
		      flash[:error] = "Failed to create a new post."
		      render :action => "new"
		    end
		  else
		    flash[:warning] = "Captcha does not match."
		    render :action => "new"
		  end
		end
  end
  
  # PUT /post_tests/1
  # PUT /post_tests/1.xml
  def update
    @post_test = PostTest.find(params[:id])
    @post = @post_test.post
    
    if (@post_test.update_attributes(params[:post_test]) && @post.update_attributes(params[:post]))
      sc = School.find(@post.school.id)
      sc.tag(@post_test, :with => params[:tag], :on => :tags)
      redirect_to post_test_url(@post_test)
    end
  end
  
  # DELETE /post_tests/1
  # DELETE /post_tests/1.xml
  def destroy
    @post_test = PostTest.find(params[:id])
    @post_test.post.favorites.destroy_all
    del_post_wall(@post_test)
    @post_test.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  def quick_post_form
    @class_name = "PostTest"
    render :partial => "form_request_test"
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_test_path
    @class_name = "PostTest"
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
    post_test = PostTest.find(params[:id])
    post = post_test.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user))) || current_user.has_role?(:admin)
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
