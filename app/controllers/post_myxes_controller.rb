# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostMyxesController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :tag]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag]
  #before_filter :login_required, :except => [:index, :show, :search, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :tag]
  
  # GET /post_myxes
  # GET /post_myxes.xml
  def index
    @rating_status = params[:rating_status]
    @rating_status ||= ""
    @posts = PostMyx.paginated_post_conditions_with_option(params, @school, @rating_status)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    @post_p = @post.post_myx
    @post_p.rate rating.to_i, current_user
    # Update rating status
    score_good = @post_p.score_good
    score_bored = @post_p.score_bored
    score_bad = @post_p.score_bad
    
    if score_good == score_bored && score_bored == score_bad
      status = "Require Rating"
    else
      sort_rating_status = {"Good" => score_good, "Bored" => score_bored, "Bad" => score_bad}
      arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
      status = arr_rating_status.last.first
    end
    
    @post_p.rating_status = status
    
    @post_p.save
  end
  
  def require_rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    @post_p = @post.post_myx
    if !PostMyx.find_rated_by(current_user).include?(@post_p)
      @post_p.rate rating.to_i, current_user
      # Update rating status
      score_good = @post_p.score_good
      score_bored = @post_p.score_bored
      score_bad = @post_p.score_bad
      
      if score_good == score_bored && score_bored == score_bad
        status = "Require Rating"
      else
        sort_rating_status = {"Good" => score_good, "Bored" => score_bored, "Bad" => score_bad}
        arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
        status = arr_rating_status.last.first
      end
      
      @post_p.rating_status = status
      
      @post_p.save
    end
  end
  
  def tag
    @tag_name = params[:tag_name]
    @posts = PostMyx.paginated_post_conditions_with_tag(params, @school, @tag_name)
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
  
  # GET /post_myxes/1
  # GET /post_myxes/1.xml
  def show
    @post_myx = PostMyx.find(params[:id])
    @post = @post_myx.post
    update_view_count(@post)
    posts_as = PostMyx.with_school(@school)
    as_next = posts_as.next(@post_myx.id).first
    as_prev = posts_as.previous(@post_myx.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_myx }
    end
  end
  
  # GET /post_myxes/new
  # GET /post_myxes/new.xml
  def new
    @post_myx = PostMyx.new
    @post = Post.new
    @post_myx.post = @post
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_myx }
    end
  end
  
  # GET /post_myxes/1/edit
  def edit
    @post_myx = PostMyx.find(params[:id])
    @post = @post_myx.post
    @tag_list = @post_myx.tags_from(@post.school).join(", ")
  end
  
  # POST /post_myxes
  # POST /post_myxes.xml
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post.save
    @post_myx = PostMyx.new(params[:post_myx])
    @post.school.tag(@post_myx, :with => params[:tag], :on => :tags)
    @post.school.owned_taggings
    @post.school.owned_tags
    @post_myx.tag_list = params[:tag]
    @post_myx.post = @post
    if simple_captcha_valid?
      if @post_myx.save
        flash.now[:notice] = "Your post was successfully created."
        post_wall(@post, post_myx_path(@post))
        redirect_to post_myxes_path
      else
        error "Failed to create a new post."
        render :action => "new"
      end
    else
      flash.now[:warning] = "Captcha not match."
      render :action => "new"
    end
  end
  
  # PUT /post_myxes/1
  # PUT /post_myxes/1.xml
  def update
    @post_myx = PostFood.find(params[:id])
    @post = @post_myx.post
    
    if (@post_myx.update_attributes(params[:post_myx]) && @post_myx.post.update_attributes(params[:post]))
      @post.school.tag(@post_myx, :with => params[:tag], :on => :tags)
      redirect_to post_myx_url(@post_myx)
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
    @school = session[:your_school]
    @new_post_path = new_post_myx_path
    @class_name = "PostMyx"
    @type = PostCategory.find_by_class_name(@class_name).id
    @query = params[:search][:query] if params[:search]
  end
  
  def require_current_user
    post_myx = PostMyx.find(params[:id])
    post = post_myx.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
