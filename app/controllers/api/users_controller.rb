class Api::UsersController < ApplicationController
  before_filter :oauth_required
  
  respond_to :json, :xml
  def show
    @user = User.find_by_id(params[:id])
  end
end