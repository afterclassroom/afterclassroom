# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class FriendsController < ApplicationController
  layout 'student_lounge'
  
  before_filter :login_required
  before_filter :require_current_user
  
  def index
    @friends = @user.user_friends.paginate :page => params[:page], :per_page => 10
  end

  def search
    @search_name = ""
    if params[:search]
      @search_name = params[:search][:name]
      @friends = @user.user_friends.find(:all, :conditions => "login LIKE '%#{@search_name}%' OR name LIKE '%#{@search_name}%'").paginate :page => params[:page], :per_page => 10
    else
      @friends = @user.user_friends.paginate :page => params[:page], :per_page => 10
    end
  end

  def find
    
  end

  def recently_added

  end

  def recently_updated
    
  end
  
  def list
    if params[:group]
      @group = FriendGroup.find_by_label(params[:group])
      @friend_in_groups = @user.friend_in_groups.find(:all, :conditions => ["friend_group_id = ?", @group]).paginate :page => params[:page], :per_page => 10
    else
      redirect_to :action => "index"
    end
  end

  def invite
    
  end

  def delete
    user_id_friend = params[:user_id_friend]
    @user.user_invites.find_by_user_id_target(user_id_friend).destroy
    @user.reload
    flash[:notice] = "Delete success."
    redirect_to :action => "index"
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
