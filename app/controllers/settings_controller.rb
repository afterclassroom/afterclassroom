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

  def notiAfterclassroom

  end

  def saveNotiAfterclassroom
    
  end

  def photos

  end

  def savePhotos

  end

  def groups

  end

  def saveGroups

  end

  def pages

  end

  def savePages
    
  end

  def events

  end

  def saveEvents

  end


  def shareStory

  end

  def saveShareStory

  end

  def links

  end

  def saveLinks

  end

  def music

  end

  def saveMusic

  end

  def video

  end

  def saveVideo

  end

  def gifts

  end

  def saveGift

  end

  def helpCenter

  end

  def saveHelpCenter

  end

  def loungeComment

  end

  def saveLoungeComment

  end

  def otherApplications

  end

  def saveOtherApplications

  end

  def otherUpdates

  end

  def saveOtherUpdates

  end



end