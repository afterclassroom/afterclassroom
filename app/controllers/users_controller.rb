# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UsersController < ApplicationController
  include ApplicationHelper
  skip_before_filter :verify_authenticity_token, :only => [:create]
  protect_from_forgery :only => [:create]
  
  before_filter RubyCAS::Filter::GatewayFilter, :except => [:create]
  before_filter RubyCAS::Filter, :except => [:new, :show, :create, :forgot_password, :reset_password, :show_stories, :show_story_detail, :show_photos, :show_photo_album, :show_musics, :show_music_album, :show_videos, :show_friends, :show_fans, :warning]
  before_filter :cas_user
  #before_filter :login_required, :except => [:new, :show, :create, :activate, :forgot_password]
  before_filter :require_current_user,
    :except => [:new, :show, :create, :activate, :forgot_password, :reset_password, :show_lounge, :show_stories, :show_story_detail, :show_photos, :show_photo_album, :show_musics, :show_music_album, :show_videos, :show_friends, :show_fans, :warning]
  before_filter :get_params, :only => [:show_lounge, :show_stories, :show_story_detail, :show_photos, :show_photo_album, :show_musics, :show_music_album, :show_videos, :show_friends, :show_fans, :warning]
  # render new.rhtml
  def new
    if logged_in?
      redirect_to root_url
    else
      @user = User.new
      get_variables()
    end
  end
  
  def forgot_password
    if logged_in?
      redirect_to root_url
    else
      if params[:email]
        @email = params[:email]
        @user = User.find_by_email(@email)
        
        if @user.nil?
          error 'No account was found by that email address.'
        else
          @user.forgot_password if @user.active?
        end
      else
        # Render forgot_password.html.erb
      end
    end
  end
  
  def reset_password    
    begin
      @user = User.find_by_password_reset_code(params[:password_reset_code])
    rescue
      @user = nil
    end
    
    unless @user.nil? || !@user.active?
      @user.reset_password!
    end
    
  end
  
  def create
    logout_keeping_session!
    create_new_user(params)
  end
  
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
      when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to RubyCAS::Filter.login_url(self)
      when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.<br/>Please follow the URL from your email."
      redirect_back_or_default(root_path)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email?<br/>Or maybe you've already activated -- try signing in."
      redirect_back_or_default(root_path)
    end
  end
  
  def edit_email
  end
  
  def update_email 
    if current_user == @user
      if @user.update_attributes(:email => params[:email])
        flash[:notice] = "Your email address has been updated."
        redirect_to user_path(@user)
      else
        flash[:error] = "Your email address could not be updated."
        redirect_to edit_email_user_url(@user)
      end
    else
      flash[:error] = "You cannot update another user's email address!"
      redirect_to edit_email_user_url(@user)
    end
  end
  
  def update_avatar
    @user.avatar = params[:user][:avatar]
    @user.save!
    @user.track_activity(:updated_avatar)
    render :text => @user.avatar.url(:medium)
  end
  
  def show
    @user = User.find(params[:id])
    render :layout => "student_lounge"
  end
  
  def show_lounge
    @type = "show_lounge"
    @user = User.find(params[:id])
    @walls = @user.user_walls.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    render :layout => "student_lounge"
  end
  
  def show_stories
    if check_private_permission(@user, "my_stories")
      @stories = @user.stories.find(:all, :conditions => "state = 'share'", :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_story_detail
    if check_private_permission(@user, "my_stories")
      story_id = params[:story_id]
      @story = Story.find(story_id)
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_photos
    if check_private_permission(@user, "my_photos")
      @photo_albums = @user.photo_albums.order("created_at DESC").paginate :page => params[:page], :per_page => 16
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_photo_album
    if check_private_permission(@user, "my_photos")
      photo_album_id = params[:photo_album_id]
      @photo_album = PhotoAlbum.find(photo_album_id)
      render :layout => "photo"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_musics
    if check_private_permission(@user, "my_musics")
      @music_albums = @user.music_albums.order("created_at DESC").paginate :page => params[:page], :per_page => 16
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_music_album
    if check_private_permission(@user, "my_musics")
      music_album_id = params[:music_album_id]
      @music_album = MusicAlbum.find(music_album_id)
      @another_music_albums = @music_album.another_music_albums
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_videos
  end
  
  def show_friends
    if check_private_permission(@user, "my_friends")
      @friends = @user.user_friends.order("name ASC").paginate :page => params[:page], :per_page => 10
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_fans
    if check_private_permission(@user, "my_fans")
      fan_ids = @user.fans.order("created_at DESC").collect{|f| f.user_id}
      
      fan_results = User.ez_find(:all) do |user|
        user.id === fan_ids
      end
      @fans = fan_results.paginate({:page => params[:page], :per_page => 10})
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def warning
    render :layout => "student_lounge"
  end
  
  protected
  
  def get_params
    @user = User.find(params[:id])
  end
  
  def require_current_user
    @user ||= User.find(params[:user_id] || params[:id])
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
  
  def create_new_user(attributes)
    first_name = attributes[:first_name]
    last_name = attributes[:last_name]
    session[:first_name] = first_name
    session[:last_name] = last_name
    name = first_name + " " + last_name
    
    @user = User.new(attributes[:user])
    @user.name = name
    @user.login = to_slug(name)
    session[:your_school] = @user.school_id
    
    if @user && @user.valid?
      @user.register!
      # User information
      UserInformation.create(:user_id => @user.id)
      UserEducation.create(:user_id => @user.id)
      UserEmployment.create(:user_id => @user.id)
      # Setting notification
      notifications = Notification.find(:all)
      notifications.each do |f|
        NotifyEmailSetting.create(:user_id => @user.id, :notification_id => f.id)
      end
    end
    
    if @user.errors.empty?
      successful_creation()
    else
      failed_creation(@user, @user.errors.full_messages)
    end
  end
  
  def successful_creation()
    flash[:notice] = "Thanks for signing up!<br/>"
    flash[:notice] << "We're sending you an email with your activation code."
    redirect_back_or_default(root_path)
  end
  
  def failed_creation(user, message = 'Sorry, there was an error occured while creating account.')
    flash[:error] = message
    @user = user
    @model_name = "user"
    get_variables()
    render :action => :new
  end
  
  def get_variables
    @countries = Country.has_cities
    if session[:your_school]
      @school = School.find(session[:your_school])
      @city = @school.city
      @state = @city.state
      @country = @state.country
      @states = @country.states.has_cities
      @cities = @state.cities
      @schools = @city.schools
    else
      @country = @countries.first
      @states = @country.states.has_cities
      @state = @states.first
      @cities = @state.cities
      @city = @cities.first
      @schools = @city.schools
      @school = @schools.first
    end
  end
end
