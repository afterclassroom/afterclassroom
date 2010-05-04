# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostHousingsController < ApplicationController
  include Viewable

  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag, :good_house, :worse_house]
  before_filter :login_required, :except => [:index, :show, :search, :tag, :good_house, :worse_house]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag, :good_house, :worse_house]
  after_filter :store_go_back_url, :only => [:index, :search, :tag, :good_house, :worse_house]
  # GET /post_housings
  # GET /post_housings.xml
  def index
    @housing_category_id = params[:housing_category_id]
    @posts = PostHousing.paginated_post_conditions_with_option(params, @school, @housing_category_id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def good_house
    @posts = PostHousing.paginated_post_conditions_with_good_housing(params, @school)
  end

  def worse_house
    @posts = PostHousing.paginated_post_conditions_with_worse_housing(params, @school)
  end

  def rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_h = post.post_housing
    post_h.rate rating.to_i, current_user
    # Update rating status
    score_good = post_h.score_good
    score_bad = post_h.score_bad

    if score_good > score_bad
      status = "Good"
    elsif score_good == score_bad
      status = "Require Rating"
    else
      status = "Bad"
    end

    post_h.rating_status = status

    post_h.save

    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_h.total_good}</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;" class="vtip" title="#{Setting.get(:str_rated)}">#{post_h.total_bad}</a>
      </div>
      <script>
        vtip();
      </script>'
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
    posts_as = PostHousing.with_school(@school)
    as_next = posts_as.next(@post_housing.id).first
    as_prev = posts_as.previous(@post_housing.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
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
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_housing }
    end
  end

  # GET /post_housings/1/edit
  def edit
  end

  # POST /post_housings
  # POST /post_housings.xml
  def create
    params[:post_housing][:housing_category_ids] = params[:housing_category]
    @post_housing = PostHousing.new(params[:post_housing])
    post = Post.new(params[:post])
    post.user = current_user
    post.school_id = @school
    post.post_category_id = @type
    post.type_name = @class_name
    post.save
    @post_housing.post = post
    if @post_housing.save
      notice "Your post was successfully created."
      redirect_to post_housings_path
    else
      error "Failed to create a new post."
      render :action => "new"
    end
  end

  # PUT /post_housings/1
  # PUT /post_housings/1.xml
  def update
    params[:post_housing][:housing_category_ids] = params[:housing_category]
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
    @class_name = "PostHousing"
    @type = PostCategory.find_by_class_name(@class_name).id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    post = Post.find(params[:id])
    @post_housing = post.post_housing
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end

end
