# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class InviteController < ApplicationController
  layout 'inbox'
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :set_user
  
  def index
    @invite_message = current_user.user_invites_in.find(:all, :conditions => "is_accepted IS NULL")
  end

  def send_invite_message
    user_id_friend = params[:user_id_friend]
    invite_message = params[:invite_message]

    if (user_id_friend && invite_message)
      invite = UserInvite.create(:user_id => current_user.id, :user_id_target => user_id_friend, :message => invite_message)
      render :text => "Success"
    end
  end

  def accept
    invite_id = params[:invite_id]
    invite = current_user.user_invites_in.find_by_id(invite_id)
    invite.is_accepted = true
    invite.save
    redirect_to :action => "index"
  end

  def de_accept
    invite_id = params[:invite_id]
    invite = current_user.user_invites_in.find_by_id(invite_id)
    invite.destroy
    redirect_to :action => "index"
  end

  private
  def set_user
    @user = current_user
  end
end
