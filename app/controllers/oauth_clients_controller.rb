class OauthClientsController < ApplicationController
  layout 'developer'
  
  before_filter :login_required
  before_filter :get_client_application, :only => [:show, :edit, :update, :destroy]
  before_filter :get_variables, :only => [:new, :create, :edit_tool, :edit_tool_no_api]

  def index
    @tools = Learntool.tool_api(current_user).paginate(:page => params[:page_to_load], :per_page => 2)
    @cur_tab = "first"
  end
  
  def tab_paging
    case params[:tab_parm]
    when "first"#all tool
      @cur_page = params[:page_to_load]
      @cur_tab = "first"
      @tools = Learntool.tool_api(current_user).paginate(:page => params[:page_to_load], :per_page => 2)
    else #second
      @cur_page = params[:page_to_load]
      @cur_tab = "second"
      @tools = Learntool.tool_no_api(current_user).paginate(:page => params[:page_to_load], :per_page => 2)
    end
    
    render :layout => false
  end
  
  def edit_tool
    @tool = Learntool.find(params[:tool_id])
  end
  
  def save_edit_tool
    tool = Learntool.find(params[:tool_id])
    tool.update_attributes(params[:learntool])
    client = tool.client_application
    client.update_attributes(params[:client_application])
    if tool.save && client.save
      flash[:warning] = "Update tool successfully"
    else
      flash[:warning] = "Failed to update tool"
    end 
    redirect_to :action => "index"
  end
  
  def edit_tool_no_api
    @tool = Learntool.find(params[:tool_id])
  end
  
  def save_edit_no_api
    tool = Learntool.find(params[:tool_id])
    tool.update_attributes(params[:learntool])
    if tool.save
      flash[:warning] = "Update tool successfully"
    else
      flash[:warning] = "Failed to update tool"
    end 
    
    redirect_to :action => "index"
  end
  
  def delete_tool
    del_tool = Learntool.find(params[:tool_id])
    @tool = del_tool
    client = @tool.client_application
    
    if (client != nil)
      client.destroy
    end
    
    del_tool.destroy
    @tool
    flash[:warning] = "1 tool has been deleted"
  end
  
  def show_tool
    @tool = Learntool.find(params[:tool_id])
  end

  def new
    @client_application = ClientApplication.new
    @tool_cats = LearnToolCate.find(:all)
    @tool = Learntool.new
  end
  
  def new_from_tool
    @tool = Learntool.find(params[:tool_id])
    
    @client_application.name = @tool.name
    @client_application.url = @tool.href
    
    render :template => 'oauth_clients/new_tool_with_api' 
  end

  def create

    str_error = ""
    @client_application = current_user.client_applications.build(params[:client_application])
    @tool = Learntool.new(params[:learntool])
    @tool.user = current_user
    @tool.client_application = @client_application
    @tool.name = @client_application.name
    @tool.href = @client_application.url
    @tool.ac_api = true
    
    if simple_captcha_valid?
      if @client_application.save && @tool.save
        flash[:notice] = "Your tool has been submitted"
        redirect_to :action => "show", :id => @client_application.id
      else
        str_error = "Failed to create API !"
        flash[:notice] = str_error
        render :action => "new"
      end
    else
      flash[:warning] = "Captcha does not match."
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
  
  def get_variables
    @tool_cats = LearnToolCate.find(:all)
    params[:tool_cate] = params[:tool_cate] ? params[:tool_cate] : "-1"
  end


end
