# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PhotoAlbumsController < ApplicationController
  before_filter :login_required
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy, :delete_comment]
  # GET /photo_albums
  # GET /photo_albums.xml
  def index
    @my_photo_albums = current_user.photo_albums.find(:all, :order => "created_at DESC")
    arr_user_id = []
    if current_user.user_friends
      current_user.user_friends.each do |friend|
        arr_user_id << friend.id
      end
    end
    if arr_user_id.size > 0
      cond = Caboose::EZ::Condition.new :photo_albums do
        user_id === arr_user_id
      end
      @my_friend_photo_albums = PhotoAlbum.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_photo_albums }
    end
  end

  # GET /photo_albums/1
  # GET /photo_albums/1.xml
  def show
    @photo_album = PhotoAlbum.find(params[:id])
    @photos = @photo_album.photos.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo_album }
    end
  end

  # GET /photo_albums/new
  # GET /photo_albums/new.xml
  def new
    @photo_album = PhotoAlbum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo_album }
    end
  end

  # GET /photo_albums/1/edit
  def edit
    @photo_album = PhotoAlbum.find(params[:id])
  end

  # POST /photo_albums
  # POST /photo_albums.xml
  def create
    @photo_album = PhotoAlbum.new(params[:photo_album])
    @photo_album.user = current_user
    respond_to do |format|
      if @photo_album.save
        flash[:notice] = 'PhotoAlbum was successfully created.'
        format.html { redirect_to(@photo_album) }
        format.xml  { render :xml => @photo_album, :status => :created, :location => @photo_album }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo_album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /photo_albums/1
  # PUT /photo_albums/1.xml
  def update
    @photo_album = PhotoAlbum.find(params[:id])

    respond_to do |format|
      if @photo_album.update_attributes(params[:photo_album])
        flash[:notice] = 'PhotoAlbum was successfully updated.'
        format.html { redirect_to(@photo_album) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo_album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photo_albums/1
  # DELETE /photo_albums/1.xml
  def destroy
    @photo_album = PhotoAlbum.find(params[:id])
    @photo_album.destroy

    respond_to do |format|
      format.html { redirect_to(photo_albums_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def require_current_user
    @user ||= PhotoAlbum.find(params[:photo_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
