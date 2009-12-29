# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAssignmentsController < ApplicationController
  include Viewable
  
  before_filter :params_search_post, :only => [:index, :show, :edit]
  before_filter :login_required, :except => [:index, :show]
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index]
  # GET /post_books
  # GET /post_books.xml
  def index
    @list_years = [["Chose year", ""], ["1st Year", "1year"], ["2nd Year", "2year"], ["3rd Year", "3year"], ["4th Year", "4year"], ["Ms.C", "ms.c"], ["Ph.D", "ph.d"]]
    @list_overs = [["Over 30 days", "30"], ["Over 3 months", "90"], ["Over 6 months", "180"], ["Over 9 months", "270"], ["Over 1 year", "365"]]
    @year = params[:year] if params[:year] 
    @over = params[:over] if params[:over] 
    if params[:more_like_this_id]
      post = Post.find_by_id(params[:more_like_this_id])
      @posts = PostAssignment.paginated_post_more_like_this(post).paginate :page => params[:page], :per_page => 10
    else
      school = session[:your_school]
      @posts = PostAssignment.paginated_post_conditions_with_search(params, school).paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /post_books/1
  # GET /post_books/1.xml
  def show
    @post_book = PostBook.find(params[:id])
    @post = @post_book.post
    @post_category_id = @post.post_category_id
    @type_name = @post.post_category.name
    @comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")
    update_views(@post_book.post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_book }
    end
  end

  def show_dialog
    @post = Post.find(params[:id])
    update_views(@post)
    render :layout => false
  end

  # GET /post_books/new
  # GET /post_books/new.xml
  def new
    @post_book = PostBook.new
    post = Post.new
    @post_book.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Books"
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_book }
    end
  end

  # GET /post_books/1/edit
  def edit
    @post_book = PostBook.find(params[:id])
    @post = @post_book.post
    @post_categories = PostCategory.find(:all)
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    @school = @post_book.post.school
    @department = @post_book.post.department
  end

  # POST /post_books
  # POST /post_books.xml
  def create
    @post_book = PostBook.new(params[:post_book])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_book.post = post
    if @post_book.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_books/1
  # PUT /post_books/1.xml
  def update
    @post_book = PostBook.find(params[:id])

    if (@post_book.update_attributes(params[:post_book]) && @post_book.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_books/1
  # DELETE /post_books/1.xml
  def destroy
    @post_book = PostBook.find(params[:id])
    @post_book.destroy

    redirect_to my_post_user_url(current_user)
  end

  def update_views(obj)
    updated = update_view_count(obj)
  end

  private

def params_search_post
    @query = params[:search][:query] if params[:search] 
    @type = PostCategory.find_by_name("Assignments").id
    @search_post_path = post_assignments_path
    @new_post_path = new_post_assignment_path
end
  
  def require_current_user
    @user ||= PostAssignment.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
