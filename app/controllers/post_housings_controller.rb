# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostHousingsController < ApplicationController
  include Viewable
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index]
  # GET /post_housings
  # GET /post_housings.xml
  def index
    if params[:more_like_this_id]
      post = Post.find_by_id(params[:more_like_this_id])
      @posts = PostHousing.paginated_post_more_like_this(post).paginate :page => params[:page], :per_page => 10
    else
      if params[:search]
        @search_name = params[:search][:name]
      end

      school = session[:your_school]
      @posts = PostHousing.paginated_post_conditions_with_search(params, school).paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @post_housings }
    end
  end

  # GET /post_housings/1
  # GET /post_housings/1.xml
  def show
    @post_housing = PostHousing.find(params[:id])
    @post = @post_housing.post
    @post_category_id = @post.post_category_id
    @type_name = @post.post_category.name
    @comments = @post.comments.find(:all, :limit => 5, :order => "created_at DESC")
    update_views(@post_housing.post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_housing }
    end
  end

  def show_dialog
    @post = Post.find(params[:id])
    update_views(@post)
    render :layout => false
  end

  # GET /post_housings/new
  # GET /post_housings/new.xml
  def new
    @post_housing = PostHousing.new
    post = Post.new
    @post_housing.post = post
    @post_categories = PostCategory.find(:all)
    @post_category_name = "Housing"
    @currency = ['USD', 'CAD']
    @housing_categories = HousingCategory.find(:all)
    @countries = Country.has_cities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_housing }
    end
  end

  # GET /post_housings/1/edit
  def edit
    @post_housing = PostHousing.find(params[:id])
    @post = @post_housing.post
    @post_categories = PostCategory.find(:all)
    @housing_categories = HousingCategory.find(:all)
    @currency = ['USD', 'CAD']
    @countries = Country.has_cities
    @school = @post_housing.post.school
    @department = @post_housing.post.department
    @post_housing_category = ""
    for housing_category in @post_housing.housing_categories
      @post_housing_category += housing_category.name + ", "
    end
  end

  # POST /post_housings
  # POST /post_housings.xml
  def create
    @post_housing = PostHousing.new(params[:post_housing])
    post = Post.new(params[:post])
    post.user = current_user
    post.save
    @post_housing.post = post

    if @post_housing.save
      redirect_to my_post_user_url(current_user)
    end
  end

  # PUT /post_housings/1
  # PUT /post_housings/1.xml
  def update
    params[:post_housing][:housing_category_ids] ||= []
    @post_housing = PostHousing.find(params[:id])

    if (@post_housing.update_attributes(params[:post_housing]) && @post_housing.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_housings/1
  # DELETE /post_housings/1.xml
  def destroy
    @post_housing = PostHousing.find(params[:id])
    @post_housing.destroy

    redirect_to my_post_user_url(current_user)
  end

  def update_views(obj)
    updated = update_view_count(obj)
  end

  protected

  def require_current_user
    @user ||= PostHousing.find(params[:post_housing_id] || params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
