class SettingsController < ApplicationController
  def index

    if params[:tabname]
      puts params[:tabname]
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def networks
    
  end
end