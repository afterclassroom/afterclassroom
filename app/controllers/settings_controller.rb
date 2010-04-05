class SettingsController < ApplicationController
  before_filter :login_required
  def index
    redirect_to :action => "setting"
  end

  def setting
    notice @inf_msg
  end

  def networks
  end

  def notifications
  end

  def language
  end

  def payments
  end
  
  def ads
  end

  def changepsw
    render :layout => false
  end

  def savepsw
    @user = current_user
    @user.password = params[:password]
    if @user.save
      redirect_to :action => "setting", :inf_msg => "Updated Successfully"
    else
      redirect_to :action => "setting", :inf_msg => "Updated Failed"
    end
  end

  def changename
    render :layout => false
  end

  def savename
    @user = current_user
    @user.name = params[:changedValue]
    if @user.save
      redirect_to :action => "setting", :inf_msg => "Updated Successfully"
    else
      redirect_to :action => "setting", :inf_msg => "Updated Failed"
    end
  end

  def changeEmail
    render :layout => false
  end

  def saveEmail
    @user = current_user
    @user.email = params[:changedValue]
    if @user.save
      redirect_to :action => "setting", :inf_msg => "Updated Successfully"
    else
      redirect_to :action => "setting", :inf_msg => "Updated Failed"
    end
  end

end