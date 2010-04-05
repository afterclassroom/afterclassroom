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
    redirect_to :action => "setting", :inf_msg => "Updated Successfully"
  end

  def changename
    render :layout => false
  end

  def savename
    redirect_to :action => "setting", :inf_msg => "Updated Successfully"
  end

  def changeEmail
    render :layout => false
  end

  def saveEmail
    redirect_to :action => "setting", :inf_msg => "Updated Successfully"
  end

end