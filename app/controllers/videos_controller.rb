# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class VideosController < ApplicationController
  layout "student_lounge"
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :require_current_user,
                :only => [:edit, :update, :destroy, :delete_comment]
  # GET /videos
  # GET /videos.xml
  def index
    @friend_videos = []
    arr_user_id = []
    current_user.user_friends.collect {|f| arr_user_id << f.id if check_private_permission(f, "my_videos")}
    if arr_user_id.size > 0
      cond = Caboose::EZ::Condition.new :videos do
        user_id === arr_user_id
      end
      @friend_videos = Video.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 25
    end
    @my_videos = current_user.videos.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 25
  end
  
  def friend_p
    arr_user_id = []
    
    if current_user.user_friends
      current_user.user_friends.each do |friend|
        arr_user_id << friend.id
      end
    end
    
    @search_name = ""
    
    if params[:search]
      @search_name = params[:search][:name]
    end
    
    content_search = @search_name
    
    cond = Caboose::EZ::Condition.new :videos do
      user_id === arr_user_id
      if content_search != ""
        any do
          name =~ "%#{content_search}%"
        end
      end
    end
    
    @videos = Video.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 25
    
    render :layout => false
  end
  
  def my_p
    @search_name = ""
    
    if params[:search]
      @search_name = params[:search][:name]
    end
    
    content_search = @search_name
    id = current_user.id
    cond = Caboose::EZ::Condition.new :videos do
      if content_search != ""
        any do
          name =~ "%#{content_search}%"
        end
      end
      user_id == id
    end
    
    @videos = Video.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 25
    
    render :layout => false
  end
  
  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = Video.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end
  
  # GET /videos/new
  # GET /videos/new.xml
  def new
  end
  
  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
    @tag_list = @video.tag_list.join(", ")
  end
  
  # POST /videos
  # POST /videos.xml
  def create
    @video = Video.new(params[:video])
    @video.user = current_user
    @video.tag_list = params[:tag_list]
    respond_to do |format|
      if @video.save
        #@video.convert
        flash[:notice] = 'Video was successfully created.'
        format.html { redirect_to(user_video_url(current_user, @video)) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    @video = Video.find(params[:id])
    
    respond_to do |format|
      if @video.update_attributes(params[:video])
        @video.tag_list = params[:tag_list]
        @video.save
        flash[:notice] = 'Video was successfully updated.'
        format.html { redirect_to(@video) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /videos/1
  # DELETE /videos/1.xml
  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    
    respond_to do |format|
      format.html { redirect_to(videos_url) }
      format.xml  { head :ok }
    end
  end
  
  def create_form
    @categories ||= Youtube.video_categories
  end
  
  protected
  
  def require_current_user
    @user ||= Video.find(params[:video_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
