class OauthClientsController < ApplicationController
  before_filter :login_required
  before_filter :get_client_application, :only => [:show, :edit, :update, :destroy]
  layout 'developer'

  def index
    @client_applications = current_user.client_applications
    @tokens = current_user.tokens.find :all, :conditions => 'oauth_tokens.invalidated_at is null and oauth_tokens.authorized_at is not null'
  end

  def new
    @client_application = ClientApplication.new
  end
  
  def new_from_tool
    @tool = Learntool.find(params[:tool_id])
    
    @client_application = ClientApplication.new
    @client_application.name = @tool.name
    @client_application.url = @tool.href
    
    render :template => 'oauth_clients/new' 
  end

  def create
    @client_application = current_user.client_applications.build(params[:client_application])
    if @client_application.save!
      @tool = Learntool.find(params[:current_tool_id])
      @tool.client_application_id = @client_application.id
      @tool.save
      flash[:notice] = "Registered the information successfully"
      redirect_to :action => "show", :id => @client_application.id
    else
      flash[:notice] = "Failed"
      render :action => "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @client_application.update_attributes(params[:client_application])
      flash[:notice] = "Updated the client information successfully"
      redirect_to :action => "show", :id => @client_application.id
    else
      render :action => "edit"
    end
  end

  def destroy
    @client_application.destroy
    flash[:notice] = "Destroyed the client application registration"
    redirect_to :action => "index"
  end

  private
  def get_client_application
    unless @client_application = current_user.client_applications.find(params[:id])
      flash.now[:error] = "Wrong application id"
      raise ActiveRecord::RecordNotFound
    end
  end
end
