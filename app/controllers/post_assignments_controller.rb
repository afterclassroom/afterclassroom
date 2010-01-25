# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAssignmentsController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :search, :due_date]
  before_filter :login_required, :except => [:index, :show, :search, :due_date]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show]
  # GET /post_assignments
  # GET /post_assignments.xml
  def index
    @department = params[:department] if params[:department]
    @year = params[:year] if params[:year]
    @over = params[:over] ? params[:over] : "30"
    
    @departments = Department.of_school(@school)
    
    if params[:more_like_this_id]
      post = Post.find_by_id(params[:more_like_this_id])
      @posts = Post.paginated_post_more_like_this(post)
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
    @posts = PostAssignment.paginated_post_conditions_with_due_date(params, @school, @type)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /post_assignments/1
  # GET /post_assignments/1.xml
  def show
    @post_assignment = PostAssignment.find(params[:id])
    @post = @post_assignment.post
    update_view_count(@post_assignment.post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_assignment }
    end
  end

  # GET /post_assignments/new
  # GET /post_assignments/new.xml
  def new
    @post_assignment = PostBook.new
    post = Post.new
    @post_assignment.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Books"
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_assignment }
    end
  end

  # GET /post_assignments/1/edit
  def edit
    @post_assignment = PostBook.find(params[:id])
    @post = @post_assignment.post
    @post_categories = PostCategory.find(:all)
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    @school = @post_assignment.post.school
    @department = @post_assignment.post.department
  end

  # POST /post_assignments
  # POST /post_assignments.xml
  def create
    @post_assignment = PostBook.new(params[:post_assignment])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_assignment.post = post
    if @post_assignment.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_assignments/1
  # PUT /post_assignments/1.xml
  def update
    @post_assignment = PostBook.find(params[:id])

    if (@post_assignment.update_attributes(params[:post_assignment]) && @post_assignment.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_assignments/1
  # DELETE /post_assignments/1.xml
  def destroy
    @post_assignment = PostBook.find(params[:id])
    @post_assignment.destroy

    redirect_to my_post_user_url(current_user)
  end

  private

  def get_variables
    @type = PostCategory.find_by_name("Assignments").id
    @school = session[:your_school]
  end

  def require_current_user
    @user ||= PostAssignment.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
