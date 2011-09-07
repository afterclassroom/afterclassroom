# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class VideosController < ApplicationController
  layout "student_lounge"
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :require_current_user,
    :only => [:edit, :update]
  # GET /videos
  # GET /videos.xml
  def index
    @friend_videos = []
    arr_user_id = []
    current_user.user_friends.collect {|f| arr_user_id << f.id if check_private_permission(f, "my_videos")}
    if arr_user_id.size > 0
      cond = Caboose::EZ::Condition.new :videos do
        user_id === arr_user_id
        state == "converted"
      end
      @friend_videos = Video.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    end
    @my_videos = current_user.videos.find(:all, :conditions => ["state = ?", "converted"], :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
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
          title =~ "%#{content_search}%"
          description =~ "%#{content_search}%"
        end
      end
    end
    
    @videos = Video.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    
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
          title =~ "%#{content_search}%"
          description =~ "%#{content_search}%"
        end
      end
      user_id == id
      state == "converted"
    end
    
    @videos = Video.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    
    render :layout => false
  end
  
  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = Video.find(params[:id])
    @user = @video.user
    
    if check_private_permission(@user, "my_videos")
      update_view_count(@video)
      as_next = @user.videos.nexts(@video.id).last
      as_prev = @user.videos.previous(@video.id).first
      @next = as_next if as_next
      @prev = as_prev if as_prev
      
      #list of user has been tagged, and been verified
      #@tagged_users = TagInfo.find(:all, :conditions => ["tagable_id=? and tagable_type=? and verify=?",params[:id],"Video",true])
      @tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:id],"Video",true ] )

      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @video }
      end
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  # GET /videos/new
  def new
    @categories ||= Youtube.video_categories
    @video = Video.new()
  end
  
  # GET /videos/1/edit
  def edit
    @categories ||= Youtube.video_categories
    @video = Video.find(params[:id])
    @tag_list = @video.tag_list.join(", ")
    render :layout => false
  end
  
  # POST /videos
  # POST /videos.xml
  def create
    begin
      @video = Video.new(params[:video])
      @video.user = current_user
      @video.tag_list = params[:tag_list]
      if @video.save!
        @video.convert
        post_wall(@video)
        flash[:notice] = 'Video was successfully created.'
        redirect_to(user_video_url(current_user, @video))
      else
        flash[:error] = 'Error.'
        @categories ||= Youtube.video_categories
        render :action => "new"
      end
    rescue
      flash[:error] = 'Error.'
      @categories ||= Youtube.video_categories
      render :action => "new"
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
        format.html { redirect_to(update_video_user_videos_url(@video.user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def create_form
    @categories ||= Youtube.video_categories
    @video = Video.new()
  end
  
  def update_video
    @videos = current_user.videos.find(:all, :order => "created_at DESC")
  end
  
  def delete_videos
    list_ids = params[:list_ids]
    list_ids = list_ids.slice(0..list_ids.length - 2)
    ids = list_ids.split(", ")
    videos = current_user.videos.find(:all, :conditions => ["id IN(#{ids.join(", ")})"])
    if videos.size > 0
      videos.each do |abl|
        del_post_wall(abl)
        abl.favorites.destroy_all
        abl.destroy
      end
    end
    redirect_to(update_video_user_videos_url(current_user))
  end
  
  def add_tag
    
    share_to = params[:share_to]
    user_ids = share_to.split(",")
    if user_ids.size > 0 
      user_ids.each do |i|
        u = User.find(i)
        if u
          puts "username = #{u.name}"
        end
      end
    end
    
    
    render :layout => false
  end
  
  protected
  
  def require_current_user
    @user ||= Video.find(params[:video_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
