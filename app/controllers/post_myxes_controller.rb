# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostMyxesController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search]
  before_filter :login_required, :except => [:index, :show, :search, :profrating, :more_worse, :more_good]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search]
  after_filter :update_status, :only => [:create, :update]
  
  # GET /post_myxes
  # GET /post_myxes.xml
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

  def more_worse
    @post = PostMyx.paginated_post_conditions_with_more_worse(params)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def more_good
    @post = PostMyx.paginated_post_conditions_with_more_good(params)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def profrating
    @post_myx = PostMyx.find(params[:id])
    if params[:rateType] == "Good"
      @post_myx.good = @post_myx.good+1
      @post_myx.update_attribute("good", @post_myx.good)
    elsif params[:rateType] == "Worse"
      @post_myx.bad = @post_myx.bad + 1
      @post_myx.update_attribute("bad", @post_myx.bad)
    else
      @post_myx.bored = @post_myx.bored + 1
      @post_myx.update_attribute("bored", @post_myx.bored)
    end

    score = (@post_myx.good.to_f / (@post_myx.good.to_f + @post_myx.bored.to_f + @post_myx.bad.to_f)) * 100
    if score > 50
      @post_myx.prof_status = "Good"
      @post_myx.update_attribute("prof_status", @post_myx.prof_status)
    else
      @post_myx.prof_status = "Worse"
      @post_myx.update_attribute("prof_status", @post_myx.prof_status)
    end


    @post_myx
  end

  # GET /post_myxes/1
  # GET /post_myxes/1.xml
  def show
    @post = Post.find(params[:id])
    @post_myx = @post.post_myx
    update_view_count(@post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_myx }
    end
  end

  # GET /post_myxes/new
  # GET /post_myxes/new.xml
  def new
    @post_myx = PostMyx.new
    post = Post.new
    @post_myx.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Myxs"
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_myx }
    end
  end

  # GET /post_myxes/1/edit
  def edit
    @post_myx = PostMyx.find(params[:id])
    @post = @post_myx.post
    @post_categories = PostCategory.find(:all)
    @accept_payment = ['Cash', 'Visa', 'Master Card', 'Paypal']
    @currency = ['USD', 'CAD']
    @shipping_methods = ShippingMethod.find(:all)
    @countries = Country.has_cities
    @school = @post_myx.post.school
    @department = @post_myx.post.department
  end

  # POST /post_myxes
  # POST /post_myxes.xml
  def create
    @post_myx = PostMyx.new(params[:post_myx])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_myx.post = post
    if @post_myx.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_myxes/1
  # PUT /post_myxes/1.xml
  def update
    @post_myx = PostMyx.find(params[:id])

    if (@post_myx.update_attributes(params[:post_myx]) && @post_myx.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_myxes/1
  # DELETE /post_myxes/1.xml
  def destroy
    @post_myx = PostMyx.find(params[:id])
    @post_myx.destroy

    redirect_to my_post_user_url(current_user)
  end
  
  private

  def get_variables
    @tags = PostMyx.tag_counts
    @new_post_path = new_post_myx_path
    @type = PostCategory.find_by_name("MyX").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostMyx.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end

  def update_status
    if @post_myx.score > 50
      @post_myx.prof_status = "Good"
    else
      @post_myx.prof_status = "Worse"
    end
  end
end
