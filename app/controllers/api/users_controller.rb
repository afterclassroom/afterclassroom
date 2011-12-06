class Api::UsersController < ApplicationController
  #before_filter :oauth_required
  
  respond_to :json, :xml
  def show
    @user = User.find_by_id(params[:id])
  end
  
  def friends
    @user = User.find_by_id(params[:id])
    @friends = @user.user_friends
  end
  
  def fans
    @user = User.find_by_id(params[:id])
    @fans = @user.fans
  end
end
