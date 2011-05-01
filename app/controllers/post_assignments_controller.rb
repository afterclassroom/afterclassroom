# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAssignmentsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :due_date, :interesting, :tag]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :search, :due_date, :interesting, :tag]
  #before_filter :login_required, :except => [:index, :show, :search, :due_date, :interesting, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :due_date, :interesting, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :due_date, :interesting, :tag]
  
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
      format.html # search.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def due_date
    @posts = PostAssignment.paginated_post_conditions_with_due_date(params, @school)
    
    respond_to do |format|
      format.html # due_date.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def interesting
    @posts = PostAssignment.paginated_post_conditions_with_interesting(params, @school)
    
    respond_to do |format|
      format.html # interesting.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def tag
    @tag_name = params[:tag_name]
    @posts = PostAssignment.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  # GET /post_assignments/1
  # GET /post_assignments/1.xml
  def show
    @post_assignment = PostAssignment.find(params[:id])
    @post = @post_assignment.post
    update_view_count(@post)
    posts_as = PostAssignment.with_school(@school)
    as_next = posts_as.next(@post_assignment.id).first
    as_prev = posts_as.previous(@post_assignment.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_assignment }
    end
  end
  
  # GET /post_assignments/new
  # GET /post_assignments/new.xml
  def new
    @post_assignment = PostAssignment.new
    @post = Post.new
    @post_assignment.post = @post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_assignment }
    end
  end
  
  # GET /post_assignments/1/edit
  def edit
    @post_assignment = PostAssignment.find(params[:id])
    @post = @post_assignment.post
    @tag_list = @post_assignment.tags_from(@post.school).join(", ")
  end
  
  # POST /post_assignments
  # POST /post_assignments.xml
  def create 
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_assignment = PostAssignment.new(params[:post_assignment])
    @post_assignment.due_date = DateTime.strptime(params[:due_date], "%m/%d/%Y") if params[:due_date] != ""

    if simple_captcha_valid? 
      @post.save
      @post.school.tag(@post_assignment, :with => @tag_list, :on => :tags)
      @post_assignment.post = @post
      if @post_assignment.save
        flash[:notice] = "Your post was successfully created."
        post_wall(@post, post_assignment_path(@post))
        redirect_to post_assignments_path
      else
        flash[:error] = "Failed to create a new post."
        render :action => "new"
      end
    else
      flash[:warning] = "Captcha does not match."
      render :action => "new"
    end
  end
  
  # PUT /post_assignments/1
  # PUT /post_assignments/1.xml
  def update
    @post_assignment = PostAssignment.find(params[:id])
    @post = @post_assignment.post
    
    if (@post_assignment.update_attributes(params[:post_assignment]) && @post.update_attributes(params[:post]))
      @post_assignment.due_date = DateTime.strptime(params[:due_date], "%m/%d/%Y") if params[:due_date] != ""
      @post.school.tag(@post_assignment, :with => params[:tag], :on => :tags)
      @post_assignment.save
      redirect_to post_assignment_url(@post_assignment)
    end
  end
  
  # DELETE /post_assignments/1
  # DELETE /post_assignments/1.xml
  def destroy
    @post_assignment = PostAssignment.find(params[:id])
    @post_assignment.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  def quick_post_form
    @class_name = "PostAssignment"
    render :partial => "form_request_assignment"
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_assignment_path
    @class_name = "PostAssignment"
    @type = PostCategory.find_by_class_name(@class_name).id
    @query = params[:search][:query] if params[:search]
  end
  
  def require_current_user
    post_assignment = PostAssignment.find(params[:id])
    post = post_assignment.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
