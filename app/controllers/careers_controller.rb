class CareersController < ApplicationController
	#before_filter RubyCAS::Filter::GatewayFilter
  #before_filter RubyCAS::Filter, :except => [:index, :view_pr, :searchpr]
  #before_filter :cas_user
	before_filter :login_required, :except => [:index, :view_pr, :searchpr]

  def index
    @presses = Career.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10, :order => "created_at")
  end

  def save

    @press = Career.new(params[:story])
    @press.user = current_user
    @press.save
    
    redirect_to :action => "index"
  end
  
  def view_pr
    @pr = Career.find(params[:press_id])
  end
  
  def update
    
    pr = Career.find(params[:pr_id])
    
    pr.update_attributes(params[:career])


    if pr.save
      flash[:warning] = "Update news successfully"
    else
      flash[:warning] = "Failed to update news"
    end 

    
    redirect_to :action => "index"
  end
  
  def delpr
    pr = Career.find(params[:pr_id])
    pr.destroy
    @press_id = params[:pr_id]
  end
  
  def searchpr
    @presses  = Career.paginated_press_with_search(params)
    @str_search = params[:search_content]
    
    render :template => 'careers/index' 
  end
  
end
