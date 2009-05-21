# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class MusicsController < ApplicationController
  before_filter :login_required
  before_filter :require_current_user,
                :only => [:edit, :update, :destroy, :delete_comment]
  # GET /musics
  # GET /musics.xml
  def index
    @search_name = ""

    if params[:search]
      @search_name = params[:search][:name]
      content_search = @search_name
      cond = Caboose::EZ::Condition.new :photos do
        any{title =~ "%#{content_search}%"; description =~ "%#{content_search}%"} if content_search != ""
      end
      @musics = current_user.musics.find(:all, :conditions => cond.to_sql, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    else
      @musics = current_user.musics.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @musics }
    end
  end

  # GET /musics/1
  # GET /musics/1.xml
  def show
    @music = Music.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @music }
    end
  end

  # GET /musics/new
  # GET /musics/new.xml
  def new
    @music_albums = MusicAlbum.find(:all)
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
    case @music.who_can_see
    when 0
      @who_can_see_name = "Everyone"
    when 1
      @who_can_see_name = "Friends"
    when 2
      @who_can_see_name = "Private"
    end
    @music_album_name = @music.music_album.name
  end

  # POST /musics
  # POST /musics.xml
  def create
    @music = Music.new(params[:music])
    @music.user = current_user
    @music.tag_list = params[:tag_list]
    respond_to do |format|
      if @music.save
        flash[:notice] = 'Music was successfully created.'
        format.html { redirect_to(@music) }
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
  
  protected

  def require_current_user
    @user ||= Music.find(params[:music_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
