class PressInfosController < ApplicationController
	#before_filter RubyCAS::Filter::GatewayFilter
  #before_filter RubyCAS::Filter, :except => [:index, :view_pr, :searchpr]
  before_filter :cas_user
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
  
  def delpr
    pr = PressInfo.find(params[:pr_id])
    pr.destroy
    @press_id = params[:pr_id]
  end
  
  def searchpr
    @presses  = PressInfo.paginated_press_with_search(params)
    @str_search = params[:search_content]
    
    render :template => 'press_infos/index' 
  end
  
end
