# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class VideosController < ApplicationController
  before_filter :login_required
  before_filter :require_current_user,
                :only => [:edit, :update, :destroy, :delete_comment]
  # GET /videos
  # GET /videos.xml
  def index
    @search_name = ""

    if params[:search]
      @search_name = params[:search][:name]
      content_search = @search_name
      cond = Caboose::EZ::Condition.new :photos do
        any{title =~ "%#{content_search}%"; description =~ "%#{content_search}%"} if content_search != ""
      end
      @videos = current_user.videos.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    else
      @videos = current_user.videos.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
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
    @video_albums = VideoAlbum.find(:all)
    video_album_id = params[:video_album_id]
    @video = Video.new
    @video.video_album_id = video_album_id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end
  
  # GET /videos/1/edit
  def edit
    @video_albums = VideoAlbum.find(:all)
    @video = Video.find(params[:id])
    @tag_list = @video.tag_list.join(", ")
    case @video.who_can_see
    when 0
      @who_can_see_name = "Everyone"
    when 1
      @who_can_see_name = "Friends"
    when 2
      @who_can_see_name = "Private"
    end
    @video_album_name = @video.video_album.name
  end

  # POST /videos
  # POST /videos.xml
  def create
    @video = Video.new(params[:video])
    @video.user = current_user
    @video.tag_list = params[:tag_list]
    respond_to do |format|
      if @video.save
        flash[:notice] = 'Video was successfully created.'
        format.html { redirect_to(@video) }
        format.xml  { render :xml => @video, :status => :created, :location => @video }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
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
  protected

  def require_current_user
    @user ||= Video.find(params[:video_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
