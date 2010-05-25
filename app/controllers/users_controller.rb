# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]
  protect_from_forgery :only => [:create]

  before_filter :login_required,
    :except => [:new, :create, :activate, :forgot_login, :forgot_password, :show_comment]
  before_filter :require_current_user,
    :except => [:new, :create, :activate, :forgot_login, :forgot_password, :show_comment]
  before_filter :find_user, 
    :except => [:new, :create, :activate, :forgot_login, :forgot_password, :show_comment]
  
  # render new.rhtml
  def new
    @user = User.new
  end

  def forgot_login
    if request.put?
      begin
        @user = User.find_by_email(params[:email], :conditions => ['NOT state = ?', 'deleted'])
      rescue
        @user = nil
      end
      
      if @user.nil?
        flash.now[:error] = 'No account was found with that email address.'
      else
        UserMailer.deliver_forgot_login(@user)
      end
    else
      # Render forgot_login.html.erb
    end
    render :layout => "signin"
  end

  def forgot_password
    if request.put?
      @user = User.find_by_login_or_email(params[:email_or_login])

      if @user.nil?
        flash.now[:error] = 'No account was found by that login or email address.'
      else
        @user.forgot_password if @user.active?
      end
    else
      # Render forgot_password.html.erb
    end
    render :layout => "signin"
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
    create_new_user(params[:user])
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default(root_path)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default(root_path)
    end
  end
  
  def edit_password
  end
  
  def update_password       
    if current_user == @user
      current_password, new_password, new_password_confirmation = params[:current_password], params[:new_password], params[:new_password_confirmation]
      if User.password_digest(current_password, @user.salt) == @user.crypted_password
        if new_password == new_password_confirmation
          if new_password.blank? || new_password_confirmation.blank?
            flash[:error] = "You cannot set a blank password."
            redirect_to edit_password_user_url(@user)
          else
            @user.password = new_password
            @user.password_confirmation = new_password_confirmation
            @user.save
            flash[:notice] = "Your password has been updated."
            redirect_to user_path(@user)
          end
        else
          flash[:error] = "Your new password and it's confirmation don't match."
          redirect_to edit_password_user_url(@user)
        end
      else
        flash[:error] = "Your current password is not correct. Your password has not been updated."
        redirect_to edit_password_user_url(@user)
      end
    else
      flash[:error] = "You cannot update another user's password!"
      redirect_to edit_password_user_url(@user)
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

  def update_i_am_doing
    if current_user == @user
      @user.user_information.update_attribute(:i_am_doing, params[:i_am_doing])
      @user.track_activity(:updated_profile)
      render :text => params[:i_am_doing]
    end
  end

  def update_avatar
    @user.avatar = params[:user][:avatar]
    @user.save
    @user.track_activity(:updated_avatar)
    render :text => @user.avatar.url(:medium)
  end

  def list_friends
    @search_name = ""
    if params[:search]
      @search_name = params[:search][:name]
      @friends = @user.user_friends.find(:all, :conditions => "login LIKE '%#{@search_name}%' OR name LIKE '%#{@search_name}%'").paginate :page => params[:page], :per_page => 10
    else
      @friends = @user.user_friends.paginate :page => params[:page], :per_page => 10
    end
  end

  def delete_friend
    user_id_friend = params[:user_id_friend]
    @user.user_invites.find_by_user_id_target(user_id_friend).destroy
    @user.reload
    redirect_to :action => "list_friends"
  end

  def list_comments
    @comments = @user.comments.paginate :page => params[:page], :per_page => 10, :order => "created_at DESC"
    render :layout => "inbox"
  end

  def show_comment
  end
  
  def create_comment
    user_id_friend = params[:user_id_friend]
    comment = params[:comment]
    if comment && user_id_friend
      obj_comment = Comment.new()
      obj_comment.comment = comment
      obj_comment.user = @user
      user_friend = @user.user_friends.find_by_id(user_id_friend)
      user_friend.comments << obj_comment
    end
    render :text => "Success"
  end

  def delete_comment
    if params[:comment_id]
      comment_id = params[:comment_id]
      @user.comments.find(comment_id).destroy
    end
    redirect_to :action => "list_comments"
  end

  def show
  end

  def my_post
    @posts = @user.posts.paginate :page => params[:page], :per_page => 10, :order => "created_at DESC"
    render :layout => 'inbox'
  end

  def my_favorite
    @search_name = ""
    if params[:search]
      @search_name = params[:search][:name]
      @list_favorites = @user.favorites.find(:all, :conditions => "post_id IN (Select id from Posts where title LIKE '%#{@search_name}%' OR description LIKE '%#{@search_name}%')").paginate :page => params[:page], :per_page => 10
    else
      @list_favorites = @user.favorites.paginate :page => params[:page], :per_page => 10
    end
  end

  def delete_favorite
    if params[:favorite_id]
      favorite_id = params[:favorite_id]
      @user.favorites.find(favorite_id).destroy
    end
    redirect_to :action => "my_favorite"
  end
  
  protected

  def require_current_user
    @user ||= User.find(params[:user_id] || params[:id])
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end

  def find_user
    @user = User.find(params[:id])
  end

  def create_new_user(attributes)
    @user = User.new(attributes)
    @user.user_information = UserInformation.new()
    @user.user_education = UserEducation.new()
    @user.user_employment = UserEmployment.new()
    if @user && @user.valid?
      @user.register!
    end
    
    if @user.errors.empty?
      successful_creation(@user)
    else
      failed_creation
    end
  end
  
  def successful_creation(user)
    redirect_back_or_default(root_path)
    flash[:notice] = "Thanks for signing up!"
    flash[:notice] << " We're sending you an email with your activation code."
  end
  
  def failed_creation(message = 'Sorry, there was an error occured while creating account. Email already exist.')
    flash[:error] = message
    @countries = Country.has_cities
    @user = User.new
    @model_name = "user"
    render :action => :new
  end
end
