# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostFoodsController < ApplicationController
  

  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag]
  before_filter :login_required, :except => [:index, :show, :search, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :tag]
  # GET /post_foods
  # GET /post_foods.xml
  def index  
    @rating_status = params[:rating_status]
    @rating_status ||= ""
    @posts = PostFood.paginated_post_conditions_with_option(params, @school, @rating_status)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    @post_f = @post.post_food
    @post_f.rate rating.to_i, current_user
    # Update rating status
    score_good = @post_f.score_good
    score_cheap_but_good = @post_f.score_cheap_but_good
    score_bad = @post_f.score_bad

    if score_good == score_cheap_but_good && score_cheap_but_good == score_bad
      status = "Require Rating"
    else
      sort_rating_status = {"Good" => score_good, "Cheap but Good" => score_cheap_but_good, "Bad" => score_bad}
      arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
      status = arr_rating_status.last.first
    end

    @post_f.rating_status = status

    @post_f.save

  end

  def require_rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    post_f = post.post_food
    if !PostFood.find_rated_by(current_user).include?(post_f)
      post_f.rate rating.to_i, current_user
      # Update rating status
      score_good = post_f.score_good
      score_cheap_but_good = post_f.score_cheap_but_good
      score_bad = post_f.score_bad

      if score_good == score_cheap_but_good && score_cheap_but_good == score_bad
        status = "Require Rating"
      else
        sort_rating_status = {"Good" => score_good, "Cheap but Good" => score_cheap_but_good, "Bad" => score_bad}
        arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
        status = arr_rating_status.last.first
      end

      post_f.rating_status = status

      post_f.save
    end

    render :text => %Q'
      <div class="qashdU">
        <a href="javascript:;">#{post_f.total_good}</a>
      </div>
      <div class="cheap">
        <a href="javascript:;">Cheap but Good(#{post_f.total_cheap_but_good})</a>
      </div>
      <div class="qashdD">
        <a href="javascript:;">#{post_f.total_bad}</a>
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
    @tag_name = params[:tag_name]
    @posts = PostFood.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end


  # GET /post_foods/1
  # GET /post_foods/1.xml
  def show
    @post = Post.find(params[:id])
    @post_food = @post.post_food
    update_view_count(@post)
    posts_as = PostFood.with_school(@school)
    as_next = posts_as.next(@post_food.id).first
    as_prev = posts_as.previous(@post_food.id).first
    @next = as_next.post if as_next
    @prev = as_prev.post if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_food }
    end
  end

  # GET /post_foods/new
  # GET /post_foods/new.xml
  def new
    @post_food = PostFood.new
    @post = Post.new
    @post_food.post = @post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_food }
    end
  end

  # GET /post_foods/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /post_foods
  # POST /post_foods.xml
  def create
    @post_food = PostFood.new(params[:post_food])
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post.save
    @post_food.tag_list = params[:tag]
    @post_food.post = @post
    if @post_food.save
      flash.now[:notice] = "Your post was successfully created."
      redirect_to post_foods_path
    else
      error "Failed to create a new post."
      render :action => "new"
    end
  end

  # PUT /post_foods/1
  # PUT /post_foods/1.xml
  def update
    @post_food = PostFood.find(params[:id])

    if (@post_food.update_attributes(params[:post_food]) && @post_food.post.update_attributes(params[:post]))
      redirect_to my_post_user_url(current_user)
    end
  end

  # DELETE /post_foods/1
  # DELETE /post_foods/1.xml
  def destroy
    @post_food = PostFood.find(params[:id])
    @post_food.destroy

    redirect_to my_post_user_url(current_user)
  end

  private

  def get_variables
    @tags = PostFood.tag_counts_on(:tags)
    @new_post_path = new_post_food_path
    @class_name = "PostFood"
    @type = PostCategory.find_by_class_name(@class_name).id
    @school = session[:your_school]
    @query = params[:search][:query] if params[:search]
  end

  def require_current_user
    post = Post.find(params[:id])
    @post_food = post.post_food
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
