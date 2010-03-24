# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAssignmentsController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search, :due_date, :tag]
  before_filter :login_required, :except => [:index, :show, :search, :due_date, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :due_date, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :due_date, :tag]
  
  # GET /post_assignments
  # GET /post_assignments.xml
  def index  
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = PostAssignment.paginated_post_more_like_this(params, post)
    else
      @posts = PostAssignment.paginated_post_conditions_with_option(params, @school)
    end

    @new_assignment = PostAssignment.new

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
    @posts = PostAssignment.paginated_post_conditions_with_due_date(params, @school)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def tag
    tag_id = params[:tag_id]
    @tag = Tag.find(tag_id)
    @posts = PostAssignment.paginated_post_conditions_with_tag(params, @school, @tag.name)
  end

  # GET /post_assignments/1
  # GET /post_assignments/1.xml
  def show
    @post = Post.find(params[:id])
    @post_assignment = @post.post_assignment
    update_view_count(@post)
    posts_as = PostAssignment.with_school(@school)
    as_next = posts_as.next(@post_assignment.id).first
    as_prev = posts_as.previous(@post_assignment.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_assignment }
    end
  end

  # GET /post_assignments/new
  # GET /post_assignments/new.xml
  def new
    @post_assignment = PostAssignment.new
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
    @post_assignment = PostAssignment.find(params[:id])
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
    @post_assignment = PostAssignment.new(params[:post_assignment])
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
    @post_assignment = PostAssignment.find(params[:id])

    if (@post_assignment.update_attributes(params[:post_assignment]) && @post_assignment.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_assignments/1
  # DELETE /post_assignments/1.xml
  def destroy
    @post_assignment = PostAssignment.find(params[:id])
    @post_assignment.destroy

    redirect_to my_post_user_url(current_user)
  end

  private

  def get_variables
    @tags = PostAssignment.tag_counts
    @new_post_path = new_post_assignment_path
    @type = PostCategory.find_by_class_name("PostAssignment").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostAssignment.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
