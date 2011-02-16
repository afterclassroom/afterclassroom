class SharesController < ApplicationController
  before_filter :login_required
  before_filter :require_current_user, :only => [:update, :destroy]
  
  # GET /shares
  # GET /shares.xml
  def index
    @shares = current_user.shares
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shares }
    end
  end
  
  # GET /shares/1
  # GET /shares/1.xml
  def show
    @share = Share.find(params[:id])
    
    render :layout => false
  end
  
  # GET /shares/new
  # GET /shares/new.xml
  def new
    @share = Share.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @share }
    end
  end
  
  # GET /shares/edit
  # GET /shares/edit.xml
  def edit
    @share = Share.find(params[:id])
    
    render :layout => false
  end
  
  # POST /shares
  # POST /shares.xml
  def create
    @share = Share.new(params[:share])
    
    respond_to do |format|
      if @share.save
        current_user.shares << @share
        recipient = params[:recipient]
        user_ids = recipient.split(",")
        if user_ids.size > 0 
          user_ids.each do |i|
            u = User.find(i)
            @share.users << u if u
          end
        end
        format.html { redirect_to(user_shares_url(current_user), :notice => 'Share was successfully created.') }
        format.xml  { render :xml => @share, :status => :created, :location => @share }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @share.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /shares
  # PUT /shares.xml
  def update
    @share = Share.find(params[:id])
    recipient = params[:recipient]
    user_ids = recipient.split(",")
    if user_ids.size > 0 
      user_ids.each do |i|
        u = User.find(i)
        @share.users << u if u and !@sare.users.include?(u)
      end
    end
    respond_to do |format|
      format.html {redirect_to(user_shares_url(current_user), :notice => 'Share was successfully created.')}   
    end
  end
  
  # DELETE /shares/1
  # DELETE /shares/1.xml
  def destroy
    @share = Share.find(params[:id])
    @share.destroy
    
    respond_to do |format|
      format.html { redirect_to(shares_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def require_current_user
    share = Share.find(params[:id])
    @user ||= share.user
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
