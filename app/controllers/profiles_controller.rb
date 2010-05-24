# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ProfilesController < ApplicationController
  layout 'student_lounge'

  skip_before_filter :verify_authenticity_token, :only => [:update_about_yourself]
  before_filter :login_required
  before_filter :require_current_user
  
  def index
  end

  def show_profile
  end

  def edit_infor
    render :layout => false
  end

  def edit_edu_infor
    render :layout => false
  end

  def edit_work_infor
    render :layout => false
  end

  def update_about_yourself
    about_yourself = params["about_yourself"]
    current_user.user_information.about_yourself = about_yourself
    current_user.save
    render :text => about_yourself.to_s
  end

  def show_invite
    @user_id = params[:id]
    user = User.find_by_id(@user_id)
    @full_name = user.full_name
  end

  protected

  def require_current_user
    @user ||= User.find(params[:user_id] || params[:id])
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
