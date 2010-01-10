# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostProjectsController < ApplicationController
  include Viewable
  
  before_filter :params_search_post, :only => [:index, :show, :search, :due_date, :edit]
  before_filter :login_required, :except => [:index, :show]
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index]
  # GET /post_projects
  # GET /post_projects.xml
  def index
    @list_years = [["Chose year", ""], ["1st Year", "1year"], ["2nd Year", "2year"], ["3rd Year", "3year"], ["4th Year", "4year"], ["Ms.C", "ms.c"], ["Ph.D", "ph.d"]]
    @list_overs = [["Over 30 days", "30"], ["Over 3 months", "90"], ["Over 6 months", "180"], ["Over 9 months", "270"], ["Over 1 year", "365"]]
    @year = params[:year] if params[:year] 
    @over = params[:over] if params[:over] 
    type = PostCategory.find_by_name("Projects").id
    if params[:more_like_this_id]
      post = Post.find_by_id(params[:more_like_this_id])
      @posts = PostProject.paginated_post_more_like_this(post).paginate :page => params[:page], :per_page => 10
    else
      school = session[:your_school]
      @posts = Post.paginated_post_conditions_with_option(params, school, type)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def search
    @list_years = [["Chose year", ""], ["1st Year", "1year"], ["2nd Year", "2year"], ["3rd Year", "3year"], ["4th Year", "4year"], ["Ms.C", "ms.c"], ["Ph.D", "ph.d"]]
    @list_overs = [["Over 30 days", "30"], ["Over 3 months", "90"], ["Over 6 months", "180"], ["Over 9 months", "270"], ["Over 1 year", "365"]]
    @year = params[:year] if params[:year]
    @over = params[:over] if params[:over]
    type = PostProject.find_by_name("Projects").id
    if params[:search]
      school = session[:your_school]
      @posts = Post.paginated_post_conditions_with_search(params, school, type)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
    def due_date
      @list_years = [["Chose year", ""], ["1st Year", "1year"], ["2nd Year", "2year"], ["3rd Year", "3year"], ["4th Year", "4year"], ["Ms.C", "ms.c"], ["Ph.D", "ph.d"]]
      @list_overs = [["Over 30 days", "30"], ["Over 3 months", "90"], ["Over 6 months", "180"], ["Over 9 months", "270"], ["Over 1 year", "365"]]
      @year = params[:year] if params[:year]
      @over = params[:over] if params[:over]
      type = PostCategory.find_by_name("Projects").id
      school = session[:your_school]
      @posts = PostProject.paginated_post_conditions_with_due_date(params, school, type)
      
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @posts }
      end
    end

  # GET /post_projects/1
  # GET /post_projects/1.xml
  def show
    @post_project = PostProject.find(params[:id])
    @post = @post_project.post
    @post_category_id = @post.post_category_id
    @type_name = @post.post_category.name
    @comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")
    update_views(@post_project.post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_project }
    end
  end

  def show_dialog
    @post = Post.find(params[:id])
    update_views(@post)
    render :layout => false
  end

  # GET /post_projects/new
  # GET /post_projects/new.xml
  def new
    @post_project = PostBook.new
    post = Post.new
    @post_project.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Books"
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_project }
    end
  end

  # GET /post_projects/1/edit
  def edit
    @post_project = PostBook.find(params[:id])
    @post = @post_project.post
    @post_categories = PostCategory.find(:all)
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    @school = @post_project.post.school
    @department = @post_project.post.department
  end

  # POST /post_projects
  # POST /post_projects.xml
  def create
    @post_project = PostBook.new(params[:post_project])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_project.post = post
    if @post_project.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_projects/1
  # PUT /post_projects/1.xml
  def update
    @post_project = PostBook.find(params[:id])

    if (@post_project.update_attributes(params[:post_project]) && @post_project.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_projects/1
  # DELETE /post_projects/1.xml
  def destroy
    @post_project = PostBook.find(params[:id])
    @post_project.destroy

    redirect_to my_post_user_url(current_user)
  end

  def update_views(obj)
    updated = update_view_count(obj)
  end

  private

def params_search_post
    @query = params[:search][:query] if params[:search] 
    @type = PostCategory.find_by_name("Projects").id
    @search_post_path = post_projects_path
    @new_post_path = new_post_project_path
end
  
  def require_current_user
    @user ||= PostProject.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
