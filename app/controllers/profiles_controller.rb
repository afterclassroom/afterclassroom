# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ProfilesController < ApplicationController
  layout 'student_lounge'

  skip_before_filter :verify_authenticity_token, :only => [:update_about_yourself]
  before_filter :login_required
  before_filter :require_current_user
  
  def index
    @walls = current_user.my_walls.paginate :page => params[:page], :per_page => 10
  end

  def my_favorite
    @favorites = current_user.favorites.paginate :page => params[:page], :per_page => 10
  end
  
  def show_profile
    @user = User.find(params[:user_id])
    @walls = @user.my_walls.paginate :page => params[:page], :per_page => 10
  end

  def edit_infor
    @select_sex = {'Female' => false, 'Male' => true}
    @select_relation = ['Single', 'In a relationship', 'Engaged', 'Married', 'It is Complicated', 'In an Open Relationship']
    render :layout => false
  end

  def edit_edu_infor
    render :layout => false
  end

  def edit_work_infor
    render :layout => false
  end

  def update_infor
    @user.update_attributes(params[:user])
    @user.user_information.update_attributes(params[:user_information])
    @user.track_activity(:updated_profile)
    redirect_to show_profile_user_profiles_path(@user)
  end

  def update_edu_infor
    @user.user_education.update_attributes(params[:user_education])
    @user.track_activity(:updated_profile)
    redirect_to show_profile_user_profiles_path(@user)
  end

  def update_work_infor
    @user.user_employment.update_attributes(params[:user_employment])
    @user.track_activity(:updated_profile)
    redirect_to show_profile_user_profiles_path(@user)
  end

  def update_about_yourself
    about_yourself = params["about_yourself"]
    if current_user.user_information.nil?
      current_user.user_information = UserInformation.new()
    end
    current_user.user_information.about_yourself = about_yourself
    current_user.user_information.save
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
