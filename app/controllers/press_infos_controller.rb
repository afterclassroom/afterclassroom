class PressInfosController < ApplicationController
  def index
    @presses = PressInfo.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10, :order => "created_at")
  end
end
