class QaSendMail < ActionMailer::Base
  default :from => "technical@afterclassroom.com"
  default_url_options[:host] = "afterclassroom.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.qa_send_mail.refer_to_expert.subject
  #
  def refer_to_expert(introduce, receiver_email, post_id, current_user)
    
    @post = Post.find(post_id)
    @introduce = introduce
    @current_user = current_user

    mail :to => receiver_email, :subject => "Please response. Thank you for your support !"
    
  end
  
  def send_rsvp(current_user, params,post)
    @post = post
    @current_user = current_user
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @email = params[:email_addr]
    @tel = params[:tel_no]
    @message = params[:message_str]
    mail :to => post.user.email, :subject => "You've got mail from "+@first_name+"!"
  end
  
  def learntool_to_dev(current_user, tool)
    @tool = tool
    mail :to => tool.user.email, :subject => "You've got mail from #{current_user.name}"
  end

  def tag_vid_notify(user,video,tag_creator)
    @video = video
    @tag_creator=tag_creator
    mail :to => user.email, :subject => "You have been tagged!"
  end

  def inform_vid_owner(user,video,tag_creator)
    @video = video
    @tag_creator=tag_creator
    @user = user
    mail :to => @video.user.email, :subject => "New user has been tagged!"
  end
  
end
