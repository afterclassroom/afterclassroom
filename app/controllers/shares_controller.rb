class SharesController < ApplicationController
  layout "student_lounge"
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  before_filter :require_current_user, :only => [:update, :destroy]
  
  # GET /shares
  # GET /shares.xml
  def index
    @srt = "DESC"
    @str_f = "DESC"
    @srt = params[:sort] if params[:sort]
    @srt_f = params[:sort_f] if params[:sort_f]
    @friend_shares = current_user.friend_shares.find(:all, :order => "created_at #{@srt_f}")
    @shares = current_user.my_shares.find(:all, :order => "created_at #{@srt}")
    
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
    @share.sender = current_user
    respond_to do |format|
      if @share.save
        recipient = params[:recipient]
        user_ids = recipient.split(",")
        if user_ids.size > 0 
          user_ids.each do |i|
            u = User.find(i)
            if u
              mess = Message.new
              mess.sender_id = current_user.id
              mess.recipient_id = u.id
              mess.subject = @share.title
              content = "File: <a href=\"javascript:downloadFile('#{@share.attach.url}')\" class=\"downarrow\"><span>#{@share.attach.url}</span></a> <br/> #{@share.description}"
              mess.body = content
              mess.save
              @share.recipients << u
            end
            
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
        @share.users << u if u and !@share.users.include?(u)
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
      format.html { redirect_to(user_shares_url(current_user)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def require_current_user
    share = Share.find(params[:id])
    @user ||= User.find(share.user_id)
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end
