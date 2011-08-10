class OauthClientsController < ApplicationController
  layout 'developer'
  
  before_filter :login_required
  before_filter :get_client_application, :only => [:show, :edit, :update, :destroy]
  before_filter :get_variables, :only => [:new, :create]

  def index
    @client_applications = current_user.client_applications.paginate(:page => params[:page], :per_page => 5)
    @tokens = current_user.tokens.find :all, :conditions => 'oauth_tokens.invalidated_at is null and oauth_tokens.authorized_at is not null'
    
    @api_tools = Learntool.tool_api(current_user).paginate(:page => params[:page_to_load], :per_page => 2)
    
  end
  
  def tab_paging
    case params[:tab_parm]
    when "first"#all tool
      @cur_page = params[:page_to_load]
      @cur_tab = "first"
      @client_applications = current_user.client_applications.paginate(:page => params[:page_to_load], :per_page => 5)
    else #second
      @cur_page = params[:page_to_load]
      @cur_tab = "second"
      @client_applications = current_user.learn_tools.paginate(:page => params[:page_to_load], :per_page => 5)
    end
    
    render :layout => false
  end
  
  def edit_tool
    
  end
  
  def delete_tool
    
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
