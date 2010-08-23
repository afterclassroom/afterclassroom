# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'mp3info'

class MusicsController < ApplicationController
  layout "student_lounge"

  session :cookie_only => false, :only => :create_album
  skip_before_filter :verify_authenticity_token, :only => :create_album
  skip_before_filter :login_required
  before_filter :login_required
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy, :delete_comment]

  # GET /musics
  # GET /musics.xml
  def index
    @music_albums = current_user.music_albums
    arr_user_id = []
    current_user.user_friends.collect {|f| arr_user_id << f.id}
    cond = Caboose::EZ::Condition.new :musics do
      user_id === arr_user_id
    end
    @my_musics = current_user.musics.find(:all, :group => "music_album_id", :order => "created_at DESC").paginate :page => params[:page], :per_page => 5
    @friend_musics = Music.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 5
  end

  def friend_m
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

    cond = Caboose::EZ::Condition.new :musics do
      user_id === arr_user_id
      if content_search != ""
        title =~ "%#{content_search}%"
        description =~ "%#{content_search}%"
      end
    end

    @musics = Music.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 5

    render :layout => false
  end

  def my_m
    @search_name = ""

    if params[:search]
      @search_name = params[:search][:name]
    end

    content_search = @search_name
    id = current_user.id
    cond = Caboose::EZ::Condition.new :musics do
      user_id == id
      if content_search != ""
        title =~ "%#{content_search}%"
        description =~ "%#{content_search}%"
      end
    end

    @musics = Music.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 5

    render :layout => false
  end

  # GET /musics/1
  # GET /musics/1.xml
  def show
    @music_albums = current_user.music_albums
    @music = Music.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @music }
    end
  end

  # GET /musics/new
  # GET /musics/new.xml
  def new
    @music_albums = current_user.music_albums
    music_album_id = params[:music_album_id]

    @music = Music.new
    @music.music_album_id = music_album_id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @music }
    end
  end

  # GET /musics/1/edit
  def edit
    @music_albums = MusicAlbum.find(:all)
    @music = Music.find(params[:id])
    @tag_list = @music.tag_list.join(", ")
  end

  # POST /musics
  # POST /musics.xml
  def create
    @music = Music.new(params[:music])
    @music.user = current_user
    respond_to do |format|
      if @music.save
        mp3_info = Mp3Info.open(@music.music_attach.path)
        @music.length_in_seconds = mp3_info.length.to_i
        @music.artist = mp3_info.tag.artist
        @music.title = mp3_info.tag.title
        @music.length_in_seconds = mp3_info.length.to_i
        @music.save
        flash[:notice] = 'Music was successfully created.'
        format.html { redirect_to user_music_path(current_user, @music) }
        format.xml  { render :xml => @music, :status => :created, :location => @music }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @music.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /musics/1
  # PUT /musics/1.xml
  def update
    @music = Music.find(params[:id])

    respond_to do |format|
      if @music.update_attributes(params[:music])
        @music.tag_list = params[:tag_list]
        @music.save
        flash[:notice] = 'Music was successfully updated.'
        format.html { redirect_to(@music) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @music.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /musics/1
  # DELETE /musics/1.xml
  def destroy
    @music = Music.find(params[:id])
    @music.destroy

    respond_to do |format|
      format.html { redirect_to(musics_url) }
      format.xml  { head :ok }
    end
  end

  def create_album
    music_album = MusicAlbum.find_or_create_by_name(params[:music_album][:name])
    music_album.user = current_user
    music_album.save
    if music_album && params[:Filedata]
      music = Music.new()
      music.music_album = music_album
      music.user = current_user
      music.swfupload_file = params[:Filedata]
      if music.save
        mp3_info = Mp3Info.open(music.music_attach.path)
        music.length_in_seconds = mp3_info.length.to_i
        music.artist = mp3_info.tag.artist
        music.title = mp3_info.tag.title
        music.length_in_seconds = mp3_info.length.to_i
        music.save
      end
    end
    render :text => "Successfuly"
  end

  def create_playlist
    
  end
  
  protected

  def require_current_user
    @user ||= Music.find(params[:music_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
  
  private
  
  def convert_seconds_to_time(seconds)
    total_minutes = seconds / 1.minutes
    seconds_in_last_minute = seconds - total_minutes.minutes.seconds
    "#{total_minutes}m #{seconds_in_last_minute}s"
  end
end
