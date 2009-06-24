# © Copyright 2009 AfterClassroom.com — All Rights Reserved
# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'signin'
  skip_before_filter :verify_authenticity_token, :only => :create
  
  def new
  end

  def create
    logout_keeping_session!
    password_authentication
  end

  def destroy
		#Set all chanel have current_user to stop status and delete all current_user's messages 
		flirting_chanels = FlirtingChanel.find :all, :conditions => "user_id = #{current_user.id} Or user_id_target = #{current_user.id}"
		for chanel in flirting_chanels
			if chanel.status == 'Stop'
				chanel.status = 'End'
				chanel.flirting_messages.delete_all
			else
				chanel.status = 'Stop'
			end
			chanel.save
		end
		#Set user offline
		self.current_user.online = false
		self.current_user.save
    logout_killing_session!
    flash[:notice] = "You have been logged out."
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
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      successful_login
    else
      note_failed_signin
      @login = params[:login]
      @remember_me = params[:remember_me]
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
    redirect_back_or_default(dashboard_user_path(current_user))
    session[:your_school] = self.current_user.school.id if self.current_user.school
		#Set user online
		self.current_user.online = true
		self.current_user.save
    flash[:notice] = "Logged in successfully"
  end

  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end