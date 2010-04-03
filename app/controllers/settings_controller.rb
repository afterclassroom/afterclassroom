class SettingsController < ApplicationController
  before_filter :login_required
  def index

    redirect_to :action => "setting"
  end

  def setting
    if params[:inf_msg]
      @inf_msg =params[:inf_msg]
    else
      @inf_msg = ""
    end
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

  def change

    if params[:typeOfChange] == "name"
      @label = "Please enter new name"
    elsif params[:typeOfChange] == "email"
      @label = "Please enter new email address"
    elsif params[:typeOfChange] == "psw"
      @label = "Please enter new password"
    end
    render :layout => false
  end

  def savechange
    if params[:editType] == "name"
      puts "save name to the database "+params[:editType]
    elsif params[:editType] == "email"
      puts "save email to the database "+params[:editType]
    elsif params[:editType] == "psw"
      puts "save new password to the databsae"+params[:editType]
    end
    redirect_to :action => "setting", :inf_msg => "Updated Successfully"
  end

end