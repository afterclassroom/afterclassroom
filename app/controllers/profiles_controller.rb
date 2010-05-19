# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ProfilesController < ApplicationController
  layout 'student_lounge'
  before_filter :login_required
  before_filter :require_current_user
  
  def index
  end

  def show_profile
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
