# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class MusicAlbumsController < ApplicationController
  before_filter :login_required
  before_filter :require_current_user,
                :only => [:edit, :update, :destroy, :delete_comment]
  # GET /music_albums
  # GET /music_albums.xml
  def index
    @my_music_albums = current_user.music_albums.find(:all, :order => "created_at DESC")
    arr_user_id = []
    if current_user.user_friends
      current_user.user_friends.each do |friend|
        arr_user_id << friend.id
      end
    end
    if arr_user_id.size > 0
      cond = Caboose::EZ::Condition.new :music_albums do
        user_id === arr_user_id
      end
      @my_friend_music_albums = MusicAlbum.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_music_albums }
    end
  end
  
  # GET /music_albums/1
  # GET /music_albums/1.xml
  def show
    @music_album = MusicAlbum.find(params[:id])
    @musics = @music_album.musics.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @music_album }
    end
  end

  # GET /music_albums/new
  # GET /music_albums/new.xml
  def new
    @music_album = MusicAlbum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @music_album }
    end
  end

  # GET /music_albums/1/edit
  def edit
    @music_album = MusicAlbum.find(params[:id])
  end

  # POST /music_albums
  # POST /music_albums.xml
  def create
    @music_album = MusicAlbum.new(params[:music_album])
    @music_album.user = current_user
    respond_to do |format|
      if @music_album.save
        flash[:notice] = 'MusicAlbum was successfully created.'
        format.html { redirect_to(@music_album) }
        format.xml  { render :xml => @music_album, :status => :created, :location => @music_album }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @music_album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /music_albums/1
  # PUT /music_albums/1.xml
  def update
    @music_album = MusicAlbum.find(params[:id])

    respond_to do |format|
      if @music_album.update_attributes(params[:music_album])
        flash[:notice] = 'MusicAlbum was successfully updated.'
        format.html { redirect_to(@music_album) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @music_album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /music_albums/1
  # DELETE /music_albums/1.xml
  def destroy
    @music_album = MusicAlbum.find(params[:id])
    @music_album.destroy

    respond_to do |format|
      format.html { redirect_to(music_albums_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def require_current_user
    @user ||= MusicAlbum.find(params[:music_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
