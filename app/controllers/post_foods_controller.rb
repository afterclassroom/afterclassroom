# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostFoodsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :tag]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag]
  #before_filter :login_required, :except => [:index, :show, :search, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :new, :edit, :search, :tag]
  cache_sweeper :post_sweeper, :only => [:create, :update, :detroy]
  
  # GET /post_foods
  # GET /post_foods.xml
  def index  
    @rating_status = params[:rating_status]
    @rating_status ||= ""
    @post_results = Rails.cache.fetch("index_#{@class_name}_status#{@rating_status}_#{@school}") do
      PostFood.paginated_post_conditions_with_option(params, @school, @rating_status)
    end
    @posts = @post_results.paginate({:page => params[:page], :per_page => 10})
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
    @post_f = post.post_food
    if !PostFood.find_rated_by(current_user).include?(@post_f)
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
    render :layout => false
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
    @post_food = PostFood.find(params[:id])
    @post = @post_food.post
    @rating_status = @post_food.rating_status
    update_view_count(@post)
    posts_as = PostFood.with_school(@school).with_status(@rating_status)
    as_next = posts_as.nexts(@post_food.id).last
    as_prev = posts_as.previous(@post_food.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
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
    @post_food = PostFood.find(params[:id])
    @post = @post_food.post
    @tag_list = @post_food.tags_from(@post.school).join(", ")
  end
  
  # POST /post_foods
  # POST /post_foods.xml
  def create
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_food = PostFood.new(params[:post_food])
    
    if simple_captcha_valid? 
      @post.save
      sc = School.find(@school)
      sc.tag(@post_food, :with => @tag_list, :on => :tags)
      @post_food.post = @post
      if @post_food.save
        flash[:notice] = "Your post was successfully created."
        post_wall(@post, post_food_path(@post_food))
        redirect_to post_food_url(@post_food)
      else
        flash[:error] = "Failed to create a new post."
        render :action => "new"
      end
    else
      flash[:warning] = "Captcha does not match."
      render :action => "new"
    end
  end
  
  # PUT /post_foods/1
  # PUT /post_foods/1.xml
  def update
    @post_food = PostFood.find(params[:id])
    @post = @post_food.post
    
    if (@post_food.update_attributes(params[:post_food]) && @post_food.post.update_attributes(params[:post]))
      sc = School.find(@post.school.id)
      sc.tag(@post_food, :with => params[:tag], :on => :tags)
      redirect_to post_food_url(@post_food)
    end
  end
  
  # DELETE /post_foods/1
  # DELETE /post_foods/1.xml
  def destroy
    @post_food = PostFood.find(params[:id])
    @post_food.post.favorites.destroy_all
    @post_food.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_food_path
    @class_name = "PostFood"
    @type = PostCategory.find_by_class_name(@class_name).id
    @query = params[:search][:query] if params[:search]
    @departments = Department.of_school(@school)
    if !fragment_exist? :browser_by_subject
      if @school
        @tags = School.find(@school).owned_tags.where(["taggable_type = ?", @class_name])
      else
        @tags = eval(@class_name).tag_counts
      end
    end
  end
  
  def require_current_user
    post_food = PostFood.find(params[:id])
    post = post_food.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user))) || current_user.has_role?(:admin)
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
