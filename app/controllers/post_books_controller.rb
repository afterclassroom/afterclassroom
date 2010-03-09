# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostBooksController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search, :tag]
  before_filter :login_required, :except => [:index, :show, :search, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :tag]
  # GET /post_books
  # GET /post_books.xml
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

  def tag
    tag_id = params[:tag_id]
    @tag = Tag.find(tag_id)
    @posts = PostBook.paginated_post_conditions_with_tag(params, @school, @tag.name)
  end

  # GET /post_books/1
  # GET /post_books/1.xml
  def show
    @post = Post.find(params[:id])
    @post_book = @post.post_book
    update_view_count(@post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_book }
    end
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

  def get_variables
    @tags = PostBook.tag_counts
    @new_post_path = new_post_book_path
    @type = PostCategory.find_by_name("Books").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostTutor.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
