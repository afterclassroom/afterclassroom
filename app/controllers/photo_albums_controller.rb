# -*- coding: utf-8 -*-
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class PhotoAlbumsController < ApplicationController
  layout "student_lounge"
  
  #before_filter RubyCAS::Filter::GatewayFilter
  #before_filter RubyCAS::Filter
  #before_filter :cas_user
  before_filter :login_required
  before_filter :require_current_user,
    :only => [:edit, :show, :update, :destroy]
  # GET /photo_albums
  # GET /photo_albums.xml
  def index
    @my_photo_albums = current_user.photo_albums.find(:all, :order => "created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @my_photo_albums }
    end
  end

  # GET /photo_albums/1
  # GET /photo_albums/1.xml
  def show
    @photo_album = PhotoAlbum.find(params[:id])
    @photos = @photo_album.photos.find(:all, :order => "created_at DESC")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo_album }
    end
  end

  # GET /photo_albums/1/edit
  def edit
    @photo_album = PhotoAlbum.find(params[:id])
    render :layout => false
  end

  # PUT /photo_albums/1
  # PUT /photo_albums/1.xml
  def update
    @photo_album = PhotoAlbum.find(params[:id])

    respond_to do |format|
      if @photo_album.update_attributes(params[:photo_album])
        flash[:notice] = 'PhotoAlbum was successfully updated.'
        format.html { redirect_to(user_photo_albums_url(current_user)) }
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
    @photo_album.favorites.destroy_all
    del_post_wall(@photo_album)
    @photo_album.destroy

    respond_to do |format|
      format.html { redirect_to(photo_albums_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    list_ids = params[:list_ids]
    list_ids = list_ids.slice(0..list_ids.length - 2)
    ids = list_ids.split(", ")
    photo_albums = current_user.photo_albums.find(:all, :conditions => ["id IN(#{ids.join(", ")})"])
    if photo_albums.size > 0
      photo_albums.each do |abl|
        abl.favorites.destroy_all
        del_post_wall(abl)
        abl.destroy
      end
    end
    redirect_to(user_photo_albums_url(current_user))
  end
  
  def delete_photos
    photo_album = PhotoAlbum.find(params[:id])
    list_ids = params[:list_ids]
    list_ids = list_ids.slice(0..list_ids.length - 2)
    ids = list_ids.split(", ")
    photos = current_user.photos.find(:all, :conditions => ["id IN(#{ids.join(", ")})"])
    if photos.size > 0
      photos.each do |abl|
        abl.favorites.destroy_all
        del_post_wall(abl)
        abl.destroy
      end
    end
    redirect_to(user_photo_album_url(current_user, photo_album))
  end
	
  def rate
    rating = params[:rating]
    @post = PhotoAlbum.find(params[:post_id])
    @post.rate rating.to_i, current_user
    @post.save

    #support for rate like/dislike cmt
    @str_class = "PhotoAlbum"
    
    @text = "<div class='qashdU' style='background: none;padding-top: 2px'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@post.total_good}</a></div>"
    @text << "<div class='qashdD' style='background: none;padding-top: 2px'><a href='javascript:;' class='vtip' title='#{configatron.str_rated}'>#{@post.total_bad}</a></div>"
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
