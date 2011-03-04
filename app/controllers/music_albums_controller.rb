# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class MusicAlbumsController < ApplicationController
  layout "student_lounge"
  
  before_filter :login_required
  before_filter :require_current_user,
                :only => [:edit, :update, :destroy]
  # GET /music_albums
  # GET /music_albums.xml
  def index
    @my_music_albums = current_user.music_albums.find(:all, :order => "created_at DESC")
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_music_albums }
    end
  end
  
  # GET /music_albums/1
  # GET /music_albums/1.xml
  def show
    @music_album = MusicAlbum.find(params[:id])
    @musics = @music_album.musics.find(:all, :order => "created_at DESC")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @music_album }
    end
  end

  # GET /music_albums/1/edit
  def edit
    @music_album = MusicAlbum.find(params[:id])
    render :layout => false
  end

  # PUT /music_albums/1
  # PUT /music_albums/1.xml
  def update
    @music_album = MusicAlbum.find(params[:id])

    respond_to do |format|
      if @music_album.update_attributes(params[:music_album])
        flash[:notice] = 'MusicAlbum was successfully updated.'
        format.html { redirect_to(user_music_albums_url(current_user)) }
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
  
  def delete_all
    list_ids = params[:list_ids]
    list_ids = list_ids.slice(0..list_ids.length - 2)
    ids = list_ids.split(", ")
    music_albums = current_user.music_albums.find(:all, :conditions => ["id IN(#{ids.join(", ")})"])
    if music_albums.size > 0
      music_albums.each do |abl|
        abl.destroy
      end
    end
    redirect_to(user_music_albums_url(current_user))
  end
  
  def delete_musics
    music_album = MusicAlbum.find(params[:id])
    list_ids = params[:list_ids]
    list_ids = list_ids.slice(0..list_ids.length - 2)
    ids = list_ids.split(", ")
    musics = current_user.musics.find(:all, :conditions => ["id IN(#{ids.join(", ")})"])
    if musics.size > 0
      musics.each do |abl|
        abl.destroy
      end
    end
    redirect_to(user_music_album_url(current_user, music_album))
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
