# © Copyright 2009 AfterClassroom.com — All Rights Reserved
# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  include AuthenticatedSystem
  
  skip_before_filter :verify_authenticity_token, :only => :create
  
  def new
  end

  def login_ajax
    notice "This function is available only to registered users."
    render :layout => false
  end

  def create
    logout_keeping_session!
    password_authentication
  end

  def destroy
    logout_killing_session!
    notice "You have been logged out."
    redirect_back_or_default(root_path)
  end

  def change_school
    if params[:school_id]
      school_id = params[:school_id]
      school = School.find(school_id)
      session[:your_school] = school.id
    end
    redirect_back_or_default(root_path)
  end
  
  protected

  def password_authentication
    user = User.authenticate(params[:email], params[:password])
    if user
      self.current_user = user
      successful_login
    else
      note_failed_signin
      render :action => :new
    end
  end
  
  def successful_login
    # It's possible to use OpenID only, in which
    # case the following would update a user's email and nickname
    # on login. 
    #
    # This may give conflicts when used in combination with regular
    # user accounts.
    #
    # TODO: Add a configuration option to disable regular accounts.
    #
    # current_user.update_attributes(
    #   :login => "#{params[:openid.sreg.nickname]}",
    #   :email => "#{params[:openid.sreg.email]}"
    # )
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    redirect_back_or_default(user_student_lounges_path(current_user))
    #Set session your school
    session[:your_school] = self.current_user.school.id if self.current_user.school
    notice "Logged in successfully"
  end

  def note_failed_signin
    error "Couldn't log you in as '#{params[:email]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
