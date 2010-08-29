# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class YoutubesController < ApplicationController
  layout "student_lounge"
  
  before_filter :login_required
  before_filter :require_current_user,
    :only => [:edit, :update, :destroy, :delete_comment]
  before_filter :find_video, :only => [:show, :edit, :update, :destroy]
  
  # GET /youtubes
  # GET /youtubes.xml
  def index
    @youtube =Youtube.uploaded_by_user(session[:token]) if session[:token]
  end

  # GET /youtubes/1
  # GET /youtubes/1.xml
  def show
    @video = Youtube.find_by_id(params[:id]) rescue nil
    flash[:message] = "Sorry the video is not found at Youtube" and redirect_to user_youtubes_path(current_user) unless @video
  end

  # GET /youtubes/new
  # GET /youtubes/new.xml
  def new
    @categories ||= Youtube.video_categories
  end
  
  # GET /youtubes/1/edit
  def edit
    @youtube_videos = Youtube.uploaded_by_user(session[:token])
    @video = @youtube_videos.videos.select { |video| video.id == params[:id] }
    @youtube = @video.first
    @youtube.keywords = @youtube.group.keywords
    @youtube.category = @youtube.group.category
    @categories ||= Youtube.video_categories
  end

  # POST /youtubes
  # POST /youtubes.xml
  def upload
    @upload_info = Youtube.get_upload_url(params[:video])
  end

  # PUT /youtubes/1
  # PUT /youtubes/1.xml
  def update
    if u = Youtube.update_video(params[:id], session[:token], params[:you_tube_entry]) rescue nil
      flash[:message] = "Video has been Updated Successfully."
    else
      flash[:message] = "Video has not been Updated Successfully."
    end
    redirect_to user_youtubes_path(current_user)
  end

  # DELETE /youtubes/1
  # DELETE /youtubes/1.xml
  def destroy
    yt = Youtube.delete_video(params[:id], session[:token]) rescue nil
    if yt.msg == "OK"
      flash[:message] = "Video has been sucessfully deleted."
    else
      flash[:message] = "Sorry the video has not been deleted."
    end
    redirect_to user_youtubes_path(current_user)
  end

  def authorise
    client = GData::Client::DocList.new
    if params[:token]
      client.authsub_token = params[:token] # extract the single-use token from the URL query params
      session[:token] = client.auth_handler.upgrade()
      client.authsub_token = session[:token] if session[:token]
    end
    redirect_to user_youtubes_path(current_user)
  end
  
  protected

  def require_current_user
    @user ||= Youtube.find(params[:youtube_album_id] || params[:id]).user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end

  def find_video
    flash[:message] = "Sorry the video is not found at Youtube" and redirect_to user_youtubes_path(current_user) unless @video = Youtube.find_by_id(params[:id]) rescue nil
  end
end
