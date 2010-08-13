# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PhotosController < ApplicationController
  layout "student_lounge"

  session :cookie_only => false, :only => :upload_photo_block
  skip_before_filter :verify_authenticity_token, :only => [:upload_photo_block]
  before_filter :login_required
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy, :delete_comment]
  
  # GET /photos
  # GET /photos.xml
  def index
    @photo_albums = current_user.photo_albums
    arr_user_id = []
    current_user.user_friends.collect {|f| arr_user_id << f.id}
    cond = Caboose::EZ::Condition.new :photos do
      user_id === arr_user_id
    end
    @my_photos = current_user.photos.find(:all, :group => "photo_album_id", :order => "created_at DESC").paginate :page => params[:page], :per_page => 5
    @friend_photos = Photo.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 5
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

    cond = Caboose::EZ::Condition.new :photos do
      user_id === arr_user_id
      if content_search != ""
        title =~ "%#{content_search}%"
        description =~ "%#{content_search}%"
      end
    end

    @photos = Photo.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 5

    render :layout => false
  end

  def my_p
    @search_name = ""

    if params[:search]
      @search_name = params[:search][:name]
    end

    content_search = @search_name
    id = current_user.id
    cond = Caboose::EZ::Condition.new :photos do
      user_id == id
      if content_search != ""
        title =~ "%#{content_search}%"
        description =~ "%#{content_search}%"
      end
    end

    @photos = Photo.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 5

    render :layout => false
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo_albums = current_user.photo_albums
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    @photo_albums = current_user.photo_albums
    photo_album_id = params[:photo_album_id]
    
    @photo = Photo.new
    @photo.photo_album_id = photo_album_id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo_albums = PhotoAlbum.find(:all)
    @photo = Photo.find(params[:id])
    @tag_list = @photo.tag_list.join(", ")
  end

  # POST /photos
  # POST /photos.xml
  def create
    @photo = Photo.new(params[:photo])
    @photo.user = current_user
    @photo.tag_list = params[:tag_list]
    respond_to do |format|
      if @photo.save
        flash[:notice] = 'Photo was successfully created.'
        format.html { redirect_to user_photo_path(current_user, @photo) }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        @photo.tag_list = params[:tag_list]
        @photo.save
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to(@photo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    
    respond_to do |format|
      format.html { redirect_to(photos_url) }
      format.xml  { head :ok }
    end
  end

  def create_album
    photo_album = PhotoAlbum.find_or_create_by_name(params[:photo_album][:name])
    photo_album.user = current_user
    photo_album.save
    if params[:Filedata]
      photo = Photo.new()
      photo.photo_album = photo_album
      photo.user = current_user
      photo.swfupload_file = params[:Filedata]
      photo.save!
    end
    redirect_to :text => "Successfuly"
  end

  def upload_photo_block
    photo = Photo.new(params[:photo])
    photo.user = current_user
    photo.swfupload_file = params[:Filedata]
    photo.save!
    render :text => photo.photo_attach.url(:thumb)
  end
  
  protected

  def require_current_user
    @user ||= Photo.find(params[:photo_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
