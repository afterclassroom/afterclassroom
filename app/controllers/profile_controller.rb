# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class ProfileController < ApplicationController
  def index
    @search_name = params[:search][:name] if params[:search]
    @users = User.paginated_users_conditions_with_search(params).paginate :page => params[:page], :per_page => 10
  end

  def show_profile
    @user = User.find_by_id(params[:id])
    @comments = @user.comments.find(:all, :order => "created_at DESC")
    @activities = Activity.find(:all, :conditions => ["user_id = ?", @user.id], :order => "created_at DESC", :limit => 10)
    if !@user
      redirect_to :action => "index"
    end
  end

  def show_invite
    @user_id = params[:id]
    user = User.find_by_id(@user_id)
    @full_name = user.full_name
  end
end
