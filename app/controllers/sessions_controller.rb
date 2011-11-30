# © Copyright 2009 AfterClassroom.com — All Rights Reserved
# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  include AuthenticatedSystem
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:index, :new, :change_school]
  before_filter :cas_user, :except => [:index]

	def index
		if self.current_user == nil
			type = params[:type]
			self.current_user = User.find_by_email("demotoyou@gmail.com")
		  self.current_user.update_attribute("online", true)
		  self.current_user.set_time_zone_from_ip(request.remote_ip)
		  # Set session your school
		  session[:your_school] = self.current_user.school.id
			session[:your_school_type] = self.current_user.school.type_school
			case type
				when "tools"
					redirect_to user_learn_tools_path(self.current_user)
				when "networking"
					redirect_to user_student_lounges_path(self.current_user)
				else
					redirect_to "/"
			end
		else
			redirect_to user_student_lounges_path(self.current_user)
		end
	end
  
  def new
    if logged_in?
      redirect_back_or_default(root_path)
    else
      redirect_to RubyCAS::Filter.login_url(self)
    end
  end
  
  def destroy
    flash[:notice] = "You have been logged out."
    self.current_user.update_attribute("online", false)
		if self.current_user.email == "demotoyou@gmail.com"
			self.current_user = nil
		else
    	RubyCAS::Filter.logout(self, root_url) and return
		end
  end
  
  def change_school
    if params[:school_id]
      school_id = params[:school_id]
      school = School.find(school_id)
      session[:your_school] = school.id
			session[:your_school_type] = self.current_user.school.type_school
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
