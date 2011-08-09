# © Copyright 2009 AfterClassroom.com — All Rights Reserved
# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  include AuthenticatedSystem
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter, :except => [:new, :change_school]
  before_filter :cas_user
  
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
    RubyCAS::Filter.logout(self, root_url) and return
  end
  
  def change_school
    if params[:school_id]
      school_id = params[:school_id]
      school = School.find(school_id)
      session[:your_school] = school.id
    end
    redirect_back_or_default(root_path)
  end
end
