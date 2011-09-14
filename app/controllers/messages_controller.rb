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
      @operation_ = "Sent"
    when "trash"
      @messages = Message.find(:all, :conditions => ["(sender_id = ? AND sender_deleted = ?) OR (recipient_id = ? AND recipient_deleted = ?)", current_user, true, current_user, true]).paginate :page => params[:page], :per_page => 10
      @operation_ = "Trash"
    else
      @operation_ = "Inbox"
      @messages = current_user.received_messages.paginate :page => params[:page], :per_page => 10
    end
  end
  
  def show
	@operation_ = "Inbox"
    @message = Message.read(params[:id], current_user)
  end
  
  def new
    @operation_ = "Compose"
    @message = Message.new
    @friends = current_user.user_friends
    if params[:reply_to]
      @reply_to = Message.find(params[:reply_to])
      unless @reply_to.nil?
        if @reply_to.recipient == current_user
          @message.to = @reply_to.sender.login
          subject = "#{@reply_to.subject}"
          subject = "Re: " + subject if !subject.include?("Re: ")
          @message.subject = subject
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
      subject = "#{current_user.name} sent you a message."
      content = "Hello #{@message.recipient.name},<br/>"
      content << "<p>#{current_user.name} just sent you a message from After Classroom Inbox."
      content << "<br/>Click <a href='#{user_message_url(@message.recipient, @message)}' target='blank'>here</a> to view more.</p>"
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
    when "destroy"
      msg_destroy
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
      subject = "#{current_user.name} sent you a message."
      content = "Hello #{@message.recipient.name},<br/>"
      content << "<p>#{current_user.name} just sent you a message from After Classroom Inbox."
      content << "</br/>#{@message.subject}<br/>#{@message.body}"
      content << "<br/>Click <a href='#{user_message_url(@message.recipient, @message)}' target='blank'>here</a> to view more.</p>"
      send_notification(@message.recipient, @message.subject, @message.body, "sends_me_a_message")
      @str = "You sent an email to #{@message.recipient.full_name}."
    else
      @str = "Error."
    end
    
    return @str
  end
  
  def list_friend
    q = params[:q]
    friends = current_user.user_friends#.find(:all, :conditions => ["name LIKE ?", "%" + q + "%" ])
    arr = []
    friends.each do |f|
      arr << [f.id, f.full_name, nil, "<div class='list_friend_suggest'><img src='#{f.avatar.url(:thumb)}' />#{f.full_name}</div>"]
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
#    redirect_to user_messages_path(current_user)
    params[:mailbox] = "sent"
    redirect_to params.merge!(:action => :index)


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
  
  def msg_destroy
        if params[:msg]
          params[:msg].each { |id|
            Message.destroy(id)
          }
          flash[:notice] = "Messages deleted"
        end
    
    params[:mailbox] = "trash"
    redirect_to params.merge!(:action => :index)
  end
end
