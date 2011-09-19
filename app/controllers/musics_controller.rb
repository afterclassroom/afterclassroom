# encoding: UTF-8
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
require 'mp3info'

class MusicsController < ApplicationController
  include ApplicationHelper
  layout "student_lounge"
  
  session :cookie_only => false, :only => :upload
  skip_before_filter :verify_authenticity_token, :only => :upload
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy]
  
  # GET /musics
  # GET /musics.xml
  def index
    @friend_musics = []
    @my_music_albums = current_user.music_albums.order("created_at DESC").paginate :page => params[:page], :per_page => 15
    arr_user_id = []
    current_user.user_friends.collect {|f| arr_user_id << f.id if check_private_permission(f, "my_musics")}
    @my_friend_music_albums = if arr_user_id.size > 0
      cond = Caboose::EZ::Condition.new :music_albums do
        user_id === arr_user_id
      end
      MusicAlbum.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    end
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
    
    cond = Caboose::EZ::Condition.new :music_albums do
      user_id === arr_user_id
      if content_search != ""
        name =~ "%#{content_search}%"
      end
    end
    
    @music_albums = MusicAlbum.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    
    render :layout => false
  end
  
  def my_m
    @search_name = ""
    
    if params[:search]
      @search_name = params[:search][:name]
    end
    
    content_search = @search_name
    id = current_user.id
    cond = Caboose::EZ::Condition.new :music_albums do
      user_id == id
      if content_search != ""
        name =~ "%#{content_search}%"
      end
    end
    
    @music_albums = MusicAlbum.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 15
    
    render :layout => false
  end
  
  # GET /musics/1
  # GET /musics/1.xml
  def show
    @music = Music.find(params[:id])
    @user = @music.user
    if check_private_permission(@user, "my_musics")
      update_view_count(@music)
      as_next = @music.music_album.musics.nexts(@music.id).last
      as_prev = @music.music_album.musics.previous(@music.id).first
      @next = as_next if as_next
      @prev = as_prev if as_prev
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @music }
      end
    else
      redirect_to warning_user_path(@user)
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
    @music_albums = @user.music_albums
    @music = Music.find(params[:id])
    @tag_list = @music.tag_list.join(", ")
    render :layout => false
  end
  
  # POST /musics
  # POST /musics.xml
  def create
    begin
      @music = Music.new(params[:music])
      @music.user = current_user
      if @music.save
        begin
          mp3_info = Mp3Info.open(@music.music_attach.path)
          @music.length_in_seconds = mp3_info.length.to_i
          @music.artist = mp3_info.tag.artist
          @music.title ||= mp3_info.tag.title.sub( "'", %q{\\\'} ) if mp3_info.tag.title
          @music.length_in_seconds = mp3_info.length.to_i
          @music.save!
        rescue
          # Nothing
        end
        flash[:notice] = 'Music was successfully created.'
        post_wall(@music) if check_private_permission(current_user, "my_musics")
        redirect_to user_music_album_path(current_user, @music.music_album)
      else
        render :action => "new"
      end
    rescue
      flash[:error] = 'Music was successfully created.'
      render :action => "new"
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
        format.html { redirect_to(user_music_album_url(current_user, @music.music_album)) }
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
    @music.favorites.destroy_all
    @music.destroy
    
    render :nothing => true
  end
  
  def upload
    @music = Music.new(params[:music])
    @music.user = current_user
    if @music.save
      begin
        mp3_info = Mp3Info.open(@music.music_attach.path)
        @music.length_in_seconds = mp3_info.length.to_i
        @music.artist = mp3_info.tag.artist
        @music.title ||= mp3_info.tag.title if mp3_info.tag.title
        @music.length_in_seconds = mp3_info.length.to_i
        @music.save
      rescue
        # Nothing
      end
      render :json => { :id => @music.id, :pic_path => @music.music_attach.url.to_s , :name => @music.music_attach.instance.attributes["music_attach_file_name"] }, :content_type => 'text/html'
    else
      render :json => { :result => 'error'}, :content_type => 'text/html'
    end
  end
  
  def create_form
  end
  
  def create_album
    @music_album = MusicAlbum.new()
    @music_album.name = params[:album_name]
    @music_album.user = current_user
    @music_album.swfupload_file = params[:music_album_attach] if params[:music_album_attach]
    @music_album.save
    post_wall(@music_album) if check_private_permission(current_user, "my_musics")
    render :layout => false
  end
  
  def create_playlist
    music_album_id = params[:music_album_id]
    @music_album = MusicAlbum.find(music_album_id)
    render :layout => false
  end
  
  def play_list
    @music_album = MusicAlbum.find(params[:music_album_id])
    @user = @music_album.user
    if check_private_permission(@user, "my_musics")
      @another_music_albums = @music_album.another_music_albums
      update_view_count(@music_album)
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @music_album }
      end
    else
      redirect_to warning_user_path(@user)
    end
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
