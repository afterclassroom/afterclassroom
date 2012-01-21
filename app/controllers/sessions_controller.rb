# © Copyright 2009 AfterClassroom.com — All Rights Reserved
# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  include AuthenticatedSystem
  
  #before_filter RubyCAS::Filter::GatewayFilter
  #before_filter RubyCAS::Filter, :except => [:new, :change_school]
  ##before_filter :cas_user
  
  def new
    if logged_in?
      redirect_back_or_default(root_path)
    end
  end

	def create
		service = params[:service]
		email = params[:email]
		password = params[:password]
		user = User.authenticate(email, password)
		if user
			self.current_user = user
			self.current_user.update_attribute("online", true)
      self.current_user.set_time_zone_from_ip(request.remote_ip)
			if !user.school_id.nil? and user.school_id != 0
		    # Set session your school
		    session[:your_school] = user.school.id
				session[:your_school_type] = user.school.type_school
			end
			if self.current_user.email == "demotoyou@gmail.com"
				redirect_to service	
			else
				redirect_to user_student_lounges_path(user)
			end
		else
			flash[:error] = "Incorrect username or password."
			render :action => "new"
		end
	end
  
  def destroy
    flash[:notice] = "You have been logged out."
    current_user.update_attribute("online", false)
		logout_keeping_session!
		redirect_back_or_default(root_path)
  end
  
  def change_school
    if params[:school_id]
      school_id = params[:school_id]
      school = School.find(school_id)
      session[:your_school] = school.id
			session[:your_school_type] = school.type_school
			if session[:return_to] and session[:return_to].include?("setting")
				current_user.school = school
				current_user.save!
				case school.type_school
				when "HighSchool"
						current_user.user_education.high_school = school.address
				else
						current_user.user_education.college = school.address
				end
				current_user.user_education.save
			end
    end
    redirect_back_or_default(root_path)
  end
end
