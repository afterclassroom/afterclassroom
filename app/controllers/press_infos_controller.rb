class PressInfosController < ApplicationController
  def index
    @presses = PressInfo.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10, :order => "created_at")
  end

  def save



    @press = PressInfo.new(params[:story])
    @press.user = current_user
    @press.save
    
#    PressInfo.create do |p|
#      p.user = current_user
#      p.title = params[:story_title]
#      p.content = params[:content]
#    end
    
    redirect_to :action => "index"
  end
end
