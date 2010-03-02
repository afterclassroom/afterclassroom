# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostQasController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search]
  before_filter :login_required, :except => [:index, :show, :search]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search]
  # GET /post_qas
  # GET /post_qas.xml
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

  # GET /post_qas/1
  # GET /post_qas/1.xml
  def show
    @post = Post.find(params[:id])
    @post_qa = @post.post_qa
    update_view_count(@post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_qa }
    end
  end

  # GET /post_qas/new
  # GET /post_qas/new.xml
  def new
    @post_qa = PostBook.new
    post = Post.new
    @post_qa.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Books"
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_qa }
    end
  end

  # GET /post_qas/1/edit
  def edit
    @post_qa = PostBook.find(params[:id])
    @post = @post_qa.post
    @post_categories = PostCategory.find(:all)
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    @school = @post_qa.post.school
    @department = @post_qa.post.department
  end

  # POST /post_qas
  # POST /post_qas.xml
  def create
    @post_qa = PostBook.new(params[:post_qa])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_qa.post = post
    if @post_qa.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_qas/1
  # PUT /post_qas/1.xml
  def update
    @post_qa = PostBook.find(params[:id])

    if (@post_qa.update_attributes(params[:post_qa]) && @post_qa.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_qas/1
  # DELETE /post_qas/1.xml
  def destroy
    @post_qa = PostBook.find(params[:id])
    @post_qa.destroy

    redirect_to my_post_user_url(current_user)
  end

  private

  def get_variables
    @tags = PostQa.tag_counts
    @new_post_path = new_post_qa_path
    @type = PostCategory.find_by_name("QAs").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostQa.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
