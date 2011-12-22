# -*- coding: utf-8 -*-
# © Copyright 2009 AfterClassroom.com — All Rights Reserved
include ApplicationHelper
class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]
  protect_from_forgery :only => [:create]
  
  before_filter RubyCAS::Filter::GatewayFilter, :except => [:create]
  before_filter RubyCAS::Filter, :except => [:index, :new, :show, :create, :activate, :forgot_password, :reset_password, :show_stories, :show_story_detail, :show_photos, :show_photos_with_list, :show_photo_album, :show_photo_detail, :show_musics, :show_music_album, :show_videos, :show_detail_video, :show_friends, :show_fans, :warning, :warning_media]
  before_filter :cas_user
  #before_filter :login_required, :except => [:new, :show, :create, :activate, :forgot_password]
  before_filter :require_current_user,
    :except => [:add_tag, :index, :new, :show, :create, :activate, :forgot_password, :reset_password, :show_lounge, :show_stories, :show_story_detail, :show_photos, :show_photos_with_list, :show_photo_album, :show_photo_detail, :show_musics, :show_music_album, :show_videos, :show_detail_video, :show_friends, :show_fans, :warning, :warning_media]
  before_filter :get_params, :only => [:show_lounge, :show_stories, :show_story_detail, :show_photos, :show_photos_with_list, :show_photo_album, :show_photo_detail, :show_musics, :show_music_album, :show_videos, :show_detail_video, :show_friends, :show_fans, :warning, :warning_media]
  
	# render new.rhtml
  def index
    redirect_to root_url
  end

  def list_friend_to_tag#this action support for displaying user suggestion when adding tag at Video/Photos/Music
    q = params[:q]
    friends = []
      
    current_user.user_friends.each do |usr|
      friends << usr
    end
    friends << current_user
    
    tagged_friends = TagInfo.find(:all, :conditions => ["tagable_id=? and tagable_type=?",params[:tagable_id],params[:tagable_type]])
    
    tagged_user_ids = tagged_friends.map(&:tagable_user) #array user_id of has been tagged so that should not display to user to see
    filtered_friends = friends.select { |c| !tagged_user_ids.include?(c.id) }
    
    
    arr = []
    filtered_friends.each do |f|
      arr << [f.id, f.full_name, nil, "<div class='list_friend_suggest'><img src='#{f.avatar.url(:thumb)}' />#{f.full_name}</div>"]
    end
    respond_to do |format|
      format.js { render :json => arr.to_json()}
    end
  end
  
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
    if logged_in?
      redirect_to root_url
    else
      begin
        @user = User.find_by_password_reset_code(params[:password_reset_code])
      rescue
        @user = nil
      end
      
      unless @user.nil? || !@user.active?
        @user.reset_password!
      end
    end
  end
  
  def create
    logout_keeping_session!
    create_user(params)
  end
  
  def activate
    logout_keeping_session!
		if params[:activation_code].blank?
			flash[:error] = "The activation code was missing.<br/>Please follow the URL from your email."
      redirect_back_or_default(root_path)
		else
			user = User.find_by_activation_code(params[:activation_code])
			if user
				if !user.active?
					user.activate!
      		flash[:notice] = "Signup complete! Please sign in to continue."
				end
				redirect_to RubyCAS::Filter.login_url(self)
			else
				flash[:error]  = "We couldn't find a user with that activation code -- check your email?<br/>Or maybe you've already activated -- try signing in."
				redirect_back_or_default(root_path)
			end
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
		if check_private_permission(current_user, @user, "my_lounges")
		  @type = "show_lounge"
		  @user = User.find(params[:id])
		  @walls = @user.my_walls.paginate :page => params[:page], :per_page => 10
		  render :layout => "student_lounge"
		else
			redirect_to warning_user_path(@user)
		end
  end
  
  def show_stories
    if check_private_permission(current_user, @user, "my_stories")
      @stories = @user.stories.find(:all, :conditions => "state = 'share'", :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_story_detail
		story_id = params[:story_id]
    @story = Story.find(story_id)
		@user = @story.user
    if check_private_permission(current_user, @user, "my_stories") or check_view_permission(current_user, @story)
			#finding a list of tagged users for this story
     	@tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",story_id,"Story",true ] )
     	@verify_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",story_id,"Story",false ] )
			as_next = @user.stories.nexts(@story.id, @story.state).last
      as_prev = @user.stories.previous(@story.id, @story.state).first
      @next = as_next if as_next
      @prev = as_prev if as_prev
			update_view_count(@story)
      render :layout => false
    else
      redirect_to warning_media_user_path(@user)
    end
  end
  
  def show_photos
    if check_private_permission(current_user, @user, "my_photos")
      @photo_albums = @user.photo_albums.order("created_at DESC").paginate :page => params[:page], :per_page => 16
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_photos_with_list
   if check_private_permission(current_user, @user, "my_photos")
      photo_album_id = params[:photo_album_id]
      @photo_album = PhotoAlbum.find(photo_album_id)
      update_view_count(@photo_album)
			render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end

	def show_photo_detail
		photo_id = params[:photo_id]
	  @photo = Photo.find(photo_id)
    if check_private_permission(current_user, @user, "my_photos") or check_view_permission(current_user, @photo)
      @photo_album = @photo.photo_album
      update_view_count(@photo_album)
			#display user for partial on_this_photo
		  list_friends = current_user.user_friends
		  @tag_usr = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",photo_id,"Photo",true ] )
		  
		  #find all the user need to be verified
		  @usrs_for_verify = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",photo_id,"Photo",false ] )
			as_next = @photo_album.photos.nexts(@photo.id).last
      as_prev = @photo_album.photos.previous(@photo.id).first
      @next = as_next if as_next
      @prev = as_prev if as_prev      
			render :layout => false
    else
      redirect_to warning_media_user_path(@user)
    end
  end
  
  def show_photo_album
		photo_album_id = params[:photo_album_id]
    @photo_album = PhotoAlbum.find(photo_album_id)
    if check_private_permission(current_user, @user, "my_photos") or check_view_permission(current_user, @photo_album)
      update_view_count(@photo_album)
      render :layout => false
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_musics
    if check_private_permission(current_user, @user, "my_musics")
      @music_albums = @user.music_albums.order("created_at DESC").paginate :page => params[:page], :per_page => 16
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_music_album
		music_album_id = params[:music_album_id]
    @music_album = MusicAlbum.find(music_album_id)
    if check_private_permission(current_user, @user, "my_musics") or check_view_permission(current_user, @music_album)
      @another_music_albums = @music_album.another_music_albums
			#display user that need to verify after add ta
    @usrs_for_verify = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",music_album_id,"MusicAlbum",false ] )
    @tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",music_album_id,"MusicAlbum",true ] )

      update_view_count(@music_album)
      render :layout => false
    else
      redirect_to warning_media_user_path(@user)
    end
  end
  
  def show_videos
    if check_private_permission(current_user, @user, "my_videos")
      @videos = @user.videos.order("created_at DESC").paginate :page => params[:page], :per_page => 16
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_detail_video
		video_id = params[:video_id]
    @video = Video.find(video_id)
		@user = @video.user
    if check_private_permission(current_user, @user, "my_videos") or check_view_permission(current_user, @video)
      update_view_count(@video)
      as_next = @user.videos.nexts(@video.id).last
      as_prev = @user.videos.previous(@video.id).first
      @next = as_next if as_next
      @prev = as_prev if as_prev
      
      #the following statement to support tag_friend at video
      @tagged_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:video_id],"Video",true ] )
      @verify_users = User.find(:all, :joins => "INNER JOIN tag_infos ON tag_infos.tagable_user = users.id", :conditions => ["tag_infos.tagable_id=? and tag_infos.tagable_type=? and tag_infos.verify=?",params[:video_id],"Video",false ] )
      
      render :layout => false
    else
      redirect_to warning_media_user_path(@user)
    end
  end
  
  def show_friends
    if check_private_permission(current_user, @user, "my_friends")
      @friends = @user.user_friends.paginate :page => params[:page], :per_page => 10
      render :layout => "student_lounge"
    else
      redirect_to warning_user_path(@user)
    end
  end
  
  def show_fans
    if check_private_permission(current_user, @user, "my_fans")
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

	def warning_media
    render :layout => "photo"
  end
  
  def remove_tagged
    video = Video.find(params[:video_id])
    TagInfo.refuse_vid(params[:tag_checkbox],params[:video_id])
    share_to = params[:tag_checkbox]
    share_to.each do |i|
      u = User.find(i)
      if u
        QaSendMail.tag_removed(u,video,current_user).deliver
      end
    end #end each

    redirect_to :controller=>'users', :action => 'show_detail_video', :video_id => params[:video_id], :id => params[:id]
  end
  
  def add_tag
    video = Video.find(params[:video_id])
    
    share_to = params[:share_to]
    user_ids = share_to.split(",")

    str_flash_msg = "Your request has been sent to author. The approval will be sent to your email."

    if user_ids.size > 0 
      user_ids.each do |i|
        u = User.find(i)
        if u
          #adding selected user into TagInfo
          taginfo = TagInfo.new()
          taginfo.tag_creator_id = current_user.id
          taginfo.tagable_id = params[:video_id]
          taginfo.tagable_user = u.id
          taginfo.tagable_type = "Video"
          taginfo.verify = false
          if current_user == video.user
            taginfo.verify = true
            flash[:notice] = "Your friend(s) has been tagged."
          else
            pr = video.user.private_settings.where(:type_setting => "tag_video").first
              if (pr != nil)
                if (TAGS_SETTING[pr.share_to][0] != "Verify")#which mean NO VERIFY
                  taginfo.verify = true
                  str_flash_msg = "Your tag(s) have been created"
                end
              else#user has not setting this, considered NO VERIFY BY DEFAULT
                taginfo.verify = true
              end
            flash[:notice] = str_flash_msg
          end

          if taginfo.save
            #taginfo.verify equal to TRUE when no need to pass to verifying process
            #when there is no need to verify, there is no need to wait for authorization
            QaSendMail.tag_vid_notify(u,video, current_user,taginfo.verify).deliver
            if ( (current_user != video.user) && (video.user != u) )
              #the above condition is "NOT TO SEND mail to video owner"
              #if any user tag OWNER to OWNER's video
              QaSendMail.inform_vid_owner(u,video, current_user,taginfo.verify).deliver
            end
          end
          #if save then send mail to each user here, and to video.user
        end
      end #end each
    end
    
    
    redirect_to :controller=>'users', :action => 'show_detail_video', :video_id => params[:video_id], :id => params[:id]
  end
  
  def tag_decision
    video = Video.find(params[:video_id])
    if params[:decision_id] == "ACCEPT"
      TagInfo.verify_vid(params[:checkbox],params[:video_id])
      share_to = params[:checkbox]
      share_to.each do |i|
        u = User.find(i)
        if u
          QaSendMail.tag_approved(u,video,current_user).deliver
        end
      end #end each
    else
      TagInfo.refuse_vid(params[:checkbox],params[:video_id])
      share_to = params[:checkbox]
      share_to.each do |i|
        u = User.find(i)
        if u
          QaSendMail.tag_removed(u,video,current_user).deliver
        end
      end #end each
    end
    redirect_to :controller=>'users', :action => 'show_detail_video', :video_id => params[:video_id], :id => params[:id]
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
  
  def create_user(attributes)
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
			# Setting private
			PRIVATE_SETTING.each do |type|
				setting = 6 #Every one
				PrivateSetting.create(:user_id => @user.id, :type_setting => type, :share_to => setting)
			end
      # Setting notification
      notifications = Notification.find(:all)
      notifications.each do |f|
        NotifyEmailSetting.create(:user_id => @user.id, :notification_id => f.id)
      end
			# Send email notificaton for user same school
			school = @user.school
			users = school.users.where("id <> #{@user.id}")
			if users.size > 0
				users.each do |u|
					email = u.email
					subject = "Do you know #{@user.name}?"
					content = "Dear #{u.name},<br>"
					content << "<p>You might know #{@user.name} who just joined After Classroom from #{@user.school.name}.<br>"
					content << "Click <a href='#{show_lounge_user_url(@user)}'>here</a> to check who is #{@user.name}.<br></p>"
					Delayed::Job.enqueue SignupNotificationJob.new(email, subject, content)
				end
			end
    end
    
    if @user.errors.empty?
      render :action => :successful_creation
    else
      failed_creation(@user, @user.errors.full_messages)
    end
  end
  
  def successful_creation
  end
  
  def failed_creation(user, message = 'Sorry, there was an error occured while creating account.')
    flash[:error] = message
    @user = user
    @model_name = "user"
    get_variables()
    render :action => :new
  end
  
  def get_variables
		@type_school = "University"
    @countries = Country.has_cities
    if session[:your_school]
      @school = School.find(session[:your_school])
      @city = @school.city
      @state = @city.state
      @country = @state.country
      @states = @country.states.has_cities
      @cities = @state.cities
      @schools = @city.schools.where(:type_school => @type_school)
    else
      @country = @countries.first
      @states = @country.states.has_cities
      @state = @states.first
      @cities = @state.cities
      @city = @cities.first
      @schools = @city.schools.where(:type_school => @type_school)
      @school = @schools.first
    end
  end
  
end
