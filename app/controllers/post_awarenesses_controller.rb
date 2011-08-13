# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostAwarenessesController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :tag]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag]
  #before_filter :login_required, :except => [:index, :show, :search, :tag, :view_results]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :new, :edit, :search, :tag]
  cache_sweeper :post_sweeper, :only => [:create, :update, :detroy]
  
  # GET /post_awarenesses
  # GET /post_awarenesses.xml
  def index
    @post_results = if params[:more_like_this_id]
      id = params[:more_like_this_id]
      post = Post.find_by_id(id)
      @str_department = post.department_id
      @str_year = post.school_year
      @awareness_type_id = post.post_awareness.awareness_type.id
      Rails.cache.fetch("more_like_this_department#{post.department_id}_school_year#{post.school_year}") do
        PostAwareness.paginated_post_more_like_this(params, post)
      end
    else
      @awareness_type_id = params[:awareness_type_id]
      @awareness_type_id ||= AwarenessType.find(:first).id
      Rails.cache.fetch("index_#{@class_name}_type#{@awareness_type_id}_#{@school}_year#{params[:year]}_department#{params[:department]}_over#{params[:over]}") do
        PostAwareness.paginated_post_conditions_with_option(params, @school, @awareness_type_id)
      end
    end
    @posts = @post_results.paginate({:page => params[:page], :per_page => 10})
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
    @tag_name = params[:tag_name]
    @posts = PostAwareness.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  def rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    @post_a = @post.post_awareness
    @post_a.rate rating.to_i, current_user
    # Update rating status
    score_good = @post_a.score_good
    score_bad = @post_a.score_bad
    
    if score_good > score_bad
      status = "Good"
    elsif score_good == score_bad
      status = "Require Rating"
    else
      status = "Bad"
    end
    
    @post_a.rating_status = status
    
    @post_a.save
  end
  
  def require_rate
    rating = params[:rating]
    post = Post.find(params[:post_id])
    @post_a = post.post_awareness
    if !PostAwareness.find_rated_by(current_user).include?(@post_a)
      @post_a.rate rating.to_i, current_user
      # Update rating status
      score_good = @post_a.score_good
      score_bad = @post_a.score_bad
      
      if score_good > score_bad
        status = "Good"
      elsif score_good == score_bad
        status = "Require Rating"
      else
        status = "Bad"
      end
      
      @post_a.rating_status = status
      
      @post_a.save
    end
    render :layout => false
  end
  
  
  def support
    support = params[:support]
    @post = Post.find(params[:post_id])
    post_a = @post.post_awareness
    PostAwarenessesSupport.create(:user_id => current_user.id, :post_awareness_id => post_a.id, :support => support)
    str_supported = "You`ve selected."
    str = "Reliable"
    str_not = "Not reliable"
    if @post.post_awareness.awareness_type.label == "take_action_now"
      str = "Support"
      str_not = "Not support"
    end
    @text = "<div class='support'><a href='javascript:;' class='vtip' title='#{str_supported}'>#{str}</a></div>"
    @text << "<div class='support'><a href='javascript:;' class='vtip' title='#{str_supported}'> #{str_not}</a></div>"
  end
  
  # GET /post_awarenesses/1
  # GET /post_awarenesses/1.xml
  def show
    @post_awareness = PostAwareness.find(params[:id])
    @post = @post_awareness.post
    @awareness_type_id = @post_awareness.awareness_type_id
    update_view_count(@post)
    posts_as = PostAwareness.with_school(@school)
    as_next = posts_as.nexts(@post_awareness.id).last
    as_prev = posts_as.previous(@post_awareness.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_awareness }
    end
  end
  
  # GET /post_awarenesses/new
  # GET /post_awarenesses/new.xml
  def new
    @post_awareness = PostAwareness.new
    @post = Post.new
    @post_awareness.post = @post
    @post_awareness.awareness_type_id = AwarenessType.first.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_awareness }
    end
  end
  
  # GET /post_awarenesses/1/edit
  def edit
    @post_awareness = PostAwareness.find(params[:id])
    @post = @post_awareness.post
    @tag_list = @post_awareness.tags_from(@post.school).join(", ")
  end
  
  # POST /post_awarenesses
  # POST /post_awarenesses.xml
  def create
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post_awareness = PostAwareness.new(params[:post_awareness])
    
    if simple_captcha_valid?     
      @post.save
      sc = School.find(@school)
      sc.tag(@post_awareness, :with => @tag_list, :on => :tags)
      @post_awareness.post = @post
      if @post_awareness.save
        flash[:notice] = "Your post was successfully created."
        post_wall(@post_awareness)
        redirect_to post_awareness_url(@post_awareness)
      else
        flash[:error] = "Failed to create a new post."
        render :action => "new"
      end
    else
      flash[:warning] = "Captcha does not match."
      render :action => "new"
    end
    
  end
  
  # PUT /post_awarenesses/1
  # PUT /post_awarenesses/1.xml
  def update
    @post_awareness = PostAwareness.find(params[:id])
    @post = @post_awareness.post
    
    if (@post_awareness.update_attributes(params[:post_awareness]) && @post_awareness.post.update_attributes(params[:post]))
      sc = School.find(@post.school.id)
      sc.tag(@post_awareness, :with => params[:tag], :on => :tags)
      redirect_to post_awareness_url(@post_awareness)
    end
  end
  
  # DELETE /post_awarenesses/1
  # DELETE /post_awarenesses/1.xml
  def destroy
    @post_awareness = PostAwareness.find(params[:id])
    @post_awareness.post.favorites.destroy_all
    @post_awareness.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_awareness_path
    @class_name = "PostAwareness"
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
    post_awareness = PostAwareness.find(params[:id])
    post = post_awareness.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user))) || current_user.has_role?(:admin)
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
