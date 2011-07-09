# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class MessagesController < ApplicationController
  layout 'student_lounge'
  
  before_filter RubyCAS::Filter::GatewayFilter
  before_filter RubyCAS::Filter
  before_filter :cas_user
  #before_filter :login_required
  
  def index
    act = params[:mailbox]
    case act
      when "sent"
      @messages = current_user.sent_messages.paginate :page => params[:page], :per_page => 10
      when "trash"
      @messages = Message.find(:all, :conditions => ["(sender_id = ? AND sender_deleted = ?) OR (recipient_id = ? AND recipient_deleted = ?)", current_user, true, current_user, true]).paginate :page => params[:page], :per_page => 10
    else
      @messages = current_user.received_messages.paginate :page => params[:page], :per_page => 10
    end
  end
  
  def show
    @message = Message.read(params[:id], current_user)
  end
  
  def new
    @message = Message.new
    @friends = current_user.user_friends
    if params[:reply_to]
      @reply_to = Message.find(params[:reply_to])
      unless @reply_to.nil?
        if @reply_to.recipient == current_user
          @message.to = @reply_to.sender.login
          @message.subject = "Re: #{@reply_to.subject}"
          @message.body = "\n\n*Original message*\n\n #{@reply_to.body}"
        end
      end
    end
    
    if params[:forward_to]
      @forward_to = Message.find(params[:forward_to])
      unless @forward_to.nil?
        if @forward_to.recipient == current_user or @forward_to.sender == current_user
          @message.subject = "Forward: #{@forward_to.subject}"
          @message.body = "\n\n*Original message*\n\n #{@forward_to.body}"
        end
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
    @message.sender = current_user
    @message.recipient = User.find(params[:recipient])
    
    if @message.save
      flash[:notice] = "Message sent"
      subject = "#{current_user.name} sended you a message."
      content = "#{@message.subject}<br/>Click <a href='#{user_message_url(@message.recipient, @message)}' target='blank'>here</a> to view more"
      send_notification(@message.recipient, subject, content, "sends_me_a_message")
      redirect_to user_messages_path(current_user, :mailbox => "sent")
    else
      render :action => :new
    end
  end
  
  def delete_message
    @message = Message.find(params[:id])
    if @message and (@message.recipient == current_user or @message.sender == current_user)
      if @message.recipient == current_user
        path = user_messages_path(current_user)
      elsif @message.sender == current_user
        path = user_messages_path(current_user, :mailbox => "sent")
      end
      @message.destroy
    end
    
    redirect_to path
  end
  
  def message_action
    act = params[:act]
    case act
      when "delete"
      delete_selected
      when "mark_as_read"
      mark_read_selected
      when "mark_as_unread"
      mark_unread_selected
    else
      redirect_to user_messages_path(current_user)
    end
  end
  
  def show_email
    @recipient_id = params[:recipient_id]
    render :layout => false
  end
  
  def send_message
    @message = Message.new()
    @message.sender = current_user
    recipient = User.find(params[:recipient_id])
    @message.recipient = recipient
    @message.subject = params[:subject]
    @message.body = params[:body]
    
    if @message.save
      @str = "You sent an email to #{recipient.full_name}."
    else
      @str = "Error."
    end
    
    return @str
  end
  
  def list_friend
    q = params[:q]
    friends = current_user.user_friends.find(:all, :conditions => ["name LIKE ?", "%" + q + "%" ])
    arr = []
    friends.each do |f|
      arr << {:value => f.id, :name => f.full_name, :image => f.avatar.url(:thumb)}
    end
    respond_to do |format|
      format.js { render :json => arr.to_json()}
    end
  end
  
  private
  
  def delete_selected
    if params[:msg]
      params[:msg].each { |id|
        @message = Message.find(:first, :conditions => ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, current_user, current_user])
        @message.mark_deleted(current_user) unless @message.nil?
      }
      flash[:notice] = "Messages deleted"
    end
    redirect_to user_messages_path(current_user)
  end
  
  def mark_read_selected
    if params[:msg]
      params[:msg].each { |id|
        @message = Message.read(id, current_user)
      }
      flash[:notice] = "Messages readed"
    end
    redirect_to user_messages_path(current_user)
  end
  
  def mark_unread_selected
    if params[:msg]
      params[:msg].each { |id|
        @message = Message.find(:first, :conditions => ["messages.id = ? AND recipient_id = ?", id, current_user])
        unless @message.nil?
          @message.read_at = nil
          @message.save
        end
      }
      flash[:notice] = "Messages unread"
    end
    redirect_to user_messages_path(current_user)
  end
end
