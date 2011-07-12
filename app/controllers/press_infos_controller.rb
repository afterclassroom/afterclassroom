class PressInfosController < ApplicationController
  def index
    @presses = PressInfo.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10, :order => "created_at")
  end

  def save

    @press = PressInfo.new(params[:story])
    @press.user = current_user
    @press.save
    
    redirect_to :action => "index"
  end
  
  def view_pr
    @pr = PressInfo.find(params[:press_id])
  end
  
  def update
    
    pr = PressInfo.find(params[:pr_id])
    
    pr.update_attributes(params[:press_info])


    if pr.save
      flash[:warning] = "Update news successfully"
    else
      flash[:warning] = "Failed to update news"
    end 

    
    redirect_to :action => "index"
  end
  
  def view_detail
    @pr = PressInfo.find(params[:pr_id])
  end
  
  def delpr
    pr = PressInfo.find(params[:pr_id])
    pr.destroy
  end
  
end