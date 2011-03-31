# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class UsersController < ApplicationController
  #skip_before_filter :verify_authenticity_token, :only => [:create]
  #protect_from_forgery :only => [:create]
  
  before_filter RubyCAS::Filter::GatewayFilter, :except => [:create]
  before_filter RubyCAS::Filter, :except => [:new, :show, :create, :activate, :forgot_login, :forgot_password]
  before_filter :cas_user
  #before_filter :login_required, :except => [:new, :show, :create, :activate, :forgot_login, :forgot_password]
  before_filter :require_current_user,
    :except => [:new, :show, :create, :activate, :forgot_login, :forgot_password, :show_lounge]
  
  # render new.rhtml
  def new
    @user = User.new
    get_variables()
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
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.<br/>Please follow the URL from your email."
      redirect_back_or_default(root_path)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email?<br/>Or maybe you've already activated -- try signing in."
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
        flash[:error] = "Your current password is not correct.<br/>Your password has not been updated."
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

  def update_avatar
    @user.avatar = params[:user][:avatar]
    @user.save
    @user.track_activity(:updated_avatar)
    render :text => @user.avatar.url(:medium)
  end

  def show
    @user = User.find(params[:id])
    render :layout => "student_lounge"
  end
  
  def show_lounge
    @user = User.find(params[:id])
    @walls = @user.user_walls.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
    render :layout => "student_lounge"
  end
  
  protected

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
      UserInformation.create(:user_id => @user.id)
      UserEducation.create(:user_id => @user.id)
      UserEmployment.create(:user_id => @user.id)
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
