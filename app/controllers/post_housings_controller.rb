# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostHousingsController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :search, :tag]
  before_filter :get_variables, :only => [:index]
  before_filter :login_required, :except => [:index, :show, :search, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy, :rate]
  after_filter :store_location, :only => [:index, :show, :search, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :tag]
  # GET /post_housings
  # GET /post_housings.xml
  def index
    if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @posts = Post.paginated_post_more_like_this(params, post)
    else
      @housing_category_id = params[:housing_category_id]
      @housing_category_id ||= HousingCategory.find(:first).id
      @posts = PostHousing.paginated_post_conditions_with_option(params, @school, @housing_category_id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_tt = post.post_tutor
    post_tt.rate rating.to_i, current_user
    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;">#{post.post_tutor.total_good}</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;">#{post.post_tutor.total_bad}</a>
      </div>'
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
    @posts = PostHousing.paginated_post_conditions_with_tag(params, @school, @tag.name)
  end

  # GET /post_housings/1
  # GET /post_housings/1.xml
  def show
    @post = Post.find(params[:id])
    @post_housing = @post.post_housing
    update_view_count(@post)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_housing }
    end
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

  private

  def get_variables
    @tags = PostHousing.tag_counts
    @new_post_path = new_post_housing_path
    @type = PostCategory.find_by_name("Housing").id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    @user ||= PostHousing.find(params[:id]).post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end

end
