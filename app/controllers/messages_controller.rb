# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class MessagesController < ApplicationController
  layout 'inbox'
  
  before_filter :login_required
  before_filter :set_user, :except => :show_email
  
  def index
    if params[:mailbox] == "sent"
      @messages = @user.sent_messages.paginate :page => params[:page], :per_page => 10
    else
      @messages = @user.received_messages.paginate :page => params[:page], :per_page => 10
    end
  end
  
  def show
    @message = Message.read(params[:id], current_user)
  end
  
  def new
    @message = Message.new
    @friends = @user.user_friends
    if params[:reply_to]
      @reply_to = @user.received_messages.find(params[:reply_to])
      unless @reply_to.nil?
        @message.to = @reply_to.sender.login
        @message.subject = "Re: #{@reply_to.subject}"
        @message.body = "\n\n*Original message*\n\n #{@reply_to.body}"
      end
    end

    if params[:forward_to]
      @forward_to = @user.received_messages.find(params[:forward_to])
      unless @forward_to.nil?
        @message.subject = "Forward: #{@forward_to.subject}"
        @message.body = "\n\n*Original message*\n\n #{@forward_to.body}"
      end
    end
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @friends }
      format.js do
        render :update do |page|
          page.replace_html 'list_friend_div', :partial => "list_friend"
        end
      end
    end
  end
  
  def create
    @message = Message.new(params[:message])
    @message.sender = @user
    @message.recipient = User.find_by_email(params[:message][:email])

    if @message.save
      flash[:notice] = "Message sent"
      redirect_to user_messages_path(@user)
    else
      render :action => :new
    end
  end
  
  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @message = Message.find(:first, :conditions => ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, @user, @user])
          @message.mark_deleted(@user) unless @message.nil?
        }
        flash[:notice] = "Messages deleted"
      end
      redirect_to user_message_path(@user, @messages)
    end
  end

  def show_email
    @user_id = params[:user_id]
    render :layout => false
  end
  
  def send_message
    @message = Message.new()
    @message.sender = @user
    recipient = User.find(params[:recipient_id])
    @message.recipient = recipient
    @message.subject = params[:subject]
    @message.body = params[:body]

    if @message.save
      render :text => "You sent an email to #{recipient.full_name}."
    end
  end
  
  private
  def set_user
    @user = User.find(params[:user_id])
    unless (@user && (@user.eql?(current_user)))
      redirect_back_or_default(root_path)and return false
    end
    return @user
  end
end