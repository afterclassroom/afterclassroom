# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PostEventsController < ApplicationController
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :show, :search, :tag]
  before_filter :cas_user
  before_filter :get_variables, :only => [:index, :show, :new, :create, :edit, :update, :search, :tag]
  #before_filter :login_required, :except => [:index, :show, :search, :tag]
  before_filter :require_current_user, :only => [:edit, :update, :destroy]
  after_filter :store_location, :only => [:index, :show, :search, :tag]
  after_filter :store_go_back_url, :only => [:index, :search, :tag]
  # GET /post_events
  # GET /post_events.xml
  def index  
    @event_type_id = params[:event_type_id]
    @event_type_id ||= 1
    @posts = PostEvent.paginated_post_conditions_with_option(params, @school, @event_type_id)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def rate
    rating = params[:rating]
    @post = Post.find(params[:post_id])
    @post_f = @post.post_event
    @post_f.rate rating.to_i, current_user
    # Update rating status
    score_good = @post_f.score_good
    score_bad = @post_f.score_bad
    
    if score_good == score_bad
      status = "Require Rating"
    else
      sort_rating_status = {"Good" => score_good, "Bad" => score_bad}
      arr_rating_status = sort_rating_status.sort { |a, b| a[1] <=> b[1] }
      status = arr_rating_status.last.first
    end
    
    @post_f.rating_status = status
    
    @post_f.save
    
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
    @posts = PostEvent.paginated_post_conditions_with_tag(params, @school, @tag_name)
  end
  
  
  # GET /post_events/1
  # GET /post_events/1.xml
  def show
    @post_event = PostEvent.find(params[:id])
    @post = @post_event.post
    update_view_count(@post)
    posts_as = PostEvent.with_school(@school)
    as_next = posts_as.next(@post_event.id).first
    as_prev = posts_as.previous(@post_event.id).first
    @next = as_next if as_next
    @prev = as_prev if as_prev
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_event }
    end
  end
  
  # GET /post_events/new
  # GET /post_events/new.xml
  def new
    @post_event = PostEvent.new
    @post = Post.new
    @post_event.post = @post
    @post_event.event_type_id = EventType.first.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_event }
    end
  end
  
  # GET /post_events/1/edit
  def edit
    @post_event = PostEvent.find(params[:id])
    @post = @post_event.post
    @tag_list = @post_event.tags_from(@post.school).join(", ")
  end
  
  # POST /post_events
  # POST /post_events.xml
  def create
    @tag_list = params[:tag]
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.school_id = @school
    @post.post_category_id = @type
    @post.type_name = @class_name
    @post.save
    @post_event = PostEvent.new(params[:post_event])
    @post.school.tag(@post_event, :with => params[:tag], :on => :tags)
    @post.school.owned_taggings
    @post.school.owned_tags
    @post_event.post = @post
    if simple_captcha_valid?
      if @post_event.save
        flash.now[:notice] = "Your post was successfully created."
        redirect_to post_events_path + "?event_type_id=#{@post_event.event_type_id}"
      else
        flash[:error] = "Failed to create a new post."
        render :action => "new"
      end
    else
      flash.now[:warning] = "Captcha does not match."
      render :action => "new"
    end
  end
  
  # PUT /post_events/1
  # PUT /post_events/1.xml
  def update
    @post_event = PostEvent.find(params[:id])
    @post = @post_event.post
    
    if (@post_event.update_attributes(params[:post_event]) && @post_event.post.update_attributes(params[:post]))
      @post.school.tag(@post_event, :with => params[:tag], :on => :tags)
      redirect_to post_event_url(@post_event)
    end
  end
  
  # DELETE /post_events/1
  # DELETE /post_events/1.xml
  def destroy
    @post_event = PostEvent.find(params[:id])
    @post_event.destroy
    
    redirect_to my_post_user_url(current_user)
  end
  
  private
  
  def get_variables
    @school = session[:your_school]
    @new_post_path = new_post_event_path
    @class_name = "PostEvent"
    @type = PostCategory.find_by_class_name(@class_name).id
    @query = params[:search][:query] if params[:search]
  end
  
  def require_current_user
    post_event = PostEvent.find(params[:id])
    post = post_event.post
    @user ||= post.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
