class SettingsController < ApplicationController
  before_filter :login_required
  def index

    redirect_to :action => "setting"
  end

  def setting
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

end