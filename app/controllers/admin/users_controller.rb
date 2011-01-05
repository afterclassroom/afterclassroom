# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class Admin::UsersController < ApplicationController
  require_role :admin
  layout 'admin'
  
  def reset_password
    @user = User.find(params[:id])
    @user.reset_password!
    
    flash[:notice] = "A new password has been sent to the user by email."
    redirect_to admin_user_path(@user)
  end
  
  def pending
    @users = User.paginate :all, :conditions => {:state => 'pending'}, :page => params[:page]
    render :action => 'index'
  end
  
  def suspended
    @users = User.paginate :all, :conditions => {:state => 'suspended'}, :page => params[:page]
    render :action => 'index'
  end
  
  def active
    @users = User.paginate :all, :conditions => {:state => 'active'}, :page => params[:page]
    render :action => 'index'
  end
  
  def deleted
    @users = User.paginate :all, :conditions => {:state => 'deleted'}, :page => params[:page]
    render :action => 'index'
  end
  
  def activate
    @user = User.find(params[:id])
    @user.activate!
    redirect_to admin_user_path(@user)
  end
  
  def suspend
    @user = User.find(params[:id])
    @user.suspend! 
    redirect_to admin_user_path(@user)
  end

  def unsuspend
    @user = User.find(params[:id])
    @user.unsuspend! 
    redirect_to admin_user_path(@user)
  end

  def purge
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url
  end
  
  # DELETE /admin_users/1
  # DELETE /admin_users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.delete!

    redirect_to admin_user_path(@user)
  end

  # GET /admin_users
  # GET /admin_users.xml
  def index
    @users = User.paginate :all, :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /admin_users/1
  # GET /admin_users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
end
