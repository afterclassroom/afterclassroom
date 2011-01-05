# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class VideoAlbumsController < ApplicationController
  before_filter :login_required
  before_filter :require_current_user,
                :only => [:edit, :update, :destroy, :delete_comment]
  
  # GET /video_albums
  # GET /video_albums.xml
  def index
    @my_video_albums = current_user.video_albums.find(:all, :order => "created_at DESC")
    arr_user_id = []
    if current_user.user_friends
      current_user.user_friends.each do |friend|
        arr_user_id << friend.id
      end
    end
    if arr_user_id.size > 0
      cond = Caboose::EZ::Condition.new :video_albums do
        user_id === arr_user_id
      end
      @my_friend_video_albums = VideoAlbum.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_video_albums }
    end
  end
  
  # GET /video_albums/1
  # GET /video_albums/1.xml
  def show
    @video_album = VideoAlbum.find(params[:id])
    @videos = @video_album.videos.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video_album }
    end
  end

  # GET /video_albums/new
  # GET /video_albums/new.xml
  def new
    @video_album = VideoAlbum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video_album }
    end
  end

  # GET /video_albums/1/edit
  def edit
    @video_album = VideoAlbum.find(params[:id])
  end

  # POST /video_albums
  # POST /video_albums.xml
  def create
    @video_album = VideoAlbum.new(params[:video_album])
    @video_album.user = current_user
    respond_to do |format|
      if @video_album.save
        flash[:notice] = 'VideoAlbum was successfully created.'
        format.html { redirect_to(@video_album) }
        format.xml  { render :xml => @video_album, :status => :created, :location => @video_album }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video_album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /video_albums/1
  # PUT /video_albums/1.xml
  def update
    @video_album = VideoAlbum.find(params[:id])

    respond_to do |format|
      if @video_album.update_attributes(params[:video_album])
        flash[:notice] = 'VideoAlbum was successfully updated.'
        format.html { redirect_to(@video_album) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video_album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /video_albums/1
  # DELETE /video_albums/1.xml
  def destroy
    @video_album = VideoAlbum.find(params[:id])
    @video_album.destroy

    respond_to do |format|
      format.html { redirect_to(video_albums_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def require_current_user
    @user ||= VideoAlbum.find(params[:video_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
