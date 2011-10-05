class QaSendMail < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
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

  def tag_vid_notify(user,video,tag_creator,verify_status)
    @video = video
    @tag_creator=tag_creator
    @user = user
    @statement = ""

    if (verify_status == false)
      @statement = "Please wait for the authorization from video owner."
    end
    
    
    mail :to => user.email, :subject => "You have been tagged!"
  end

  def inform_vid_owner(user,video,tag_creator, tag_verify_status)
    @video = video
    @tag_creator=tag_creator
    @user = user

    @str_of_verify = ""
    if tag_verify_status == false #FALSE means this tag need to be verified 
      @str_of_verify = "Please review and authorize !"
    end

    mail :to => @video.user.email, :subject => "New user has been tagged!"
  end

  def tag_approved(user,video,author)
    @video = video
    @user = user
    @author = author
    mail :to => @user.email, :subject => "#{author.name} has approved you to his video tag list!"
  end
  
  def tag_removed(user,video,author)
    @video = video
    @user = user
    @author = author
    mail :to => @user.email, :subject => "#{author.name} has removed you from his video tag list!"
  end

  def vid_cmt_added(user,video,content,cmt_author)
    @video = video
    @content = content
    @cmt_author = cmt_author
    @user = user
    #user.email
    mail :to => user.email, :subject => "#{cmt_author.name} has added new comment for video #{video.title}"
  end

  def tag_photo_notify(user,photo,tag_creator, verify_status)
    @photo = photo
    @tag_creator=tag_creator
    @statement = ""
    @user = user
    
    if (tag_creator != photo.user)
      #when author enable the verify process
      #we need to send mail to inform tagged_user to wait
      #other wise, author has turned off the verify process
      #we just inform user that he has been tagged only
      if (verify_status == false)
        @statement = "Please wait for the authorization from photo owner."
      end
    end
    
    mail :to => user.email, :subject => "You have been tagged!"
  end

  def inform_tag_creator(user,photo,tag_creator,tag_verify_status)
    @photo = photo
    @tag_creator=tag_creator
    @user = user

    @str_of_verify = ""
    if tag_verify_status == false #FALSE means this tag need to be verified
      @statement = "Please wait for the authorization from owner."
      mail :to => @tag_creator.email, :subject => "Your tag has been sent to photo owner!"
    end
  end

  def inform_photo_owner(user,photo,tag_creator,tag_verify_status)
    @photo = photo
    @tag_creator=tag_creator
    @user = user

    @str_of_verify = ""
    if tag_verify_status == false #FALSE means this tag need to be verified
      @str_of_verify = "Please review and authorize"
    end


    mail :to => @photo.user.email, :subject => "New user has been tagged!"
  end

  def tag_photo_approved(user,photo,author)
    @photo = photo
    @user = user
    @author = author

    mail :to => @user.email, :subject => "#{author.name} has approved you to a photo tag list!"
  end

  def tag_photo_removed(user,photo,author)
    @photo = photo
    @user = user
    @author = author
    mail :to => @user.email, :subject => "#{author.name} has removed you from a photo tag list!"
  end

  def photo_cmt_added(user,photo,content,cmt_author)
    @photo = photo
    @content = content
    @cmt_author = cmt_author
    @user = user
    #user.email
    mail :to => user.email, :subject => "#{cmt_author.name} has added new comment for photo #{photo.title}"
  end

  def tag_photo_approved_to_creator(tag_creator,photo,author,user)
    @photo = photo
    @tag_creator = tag_creator
    @author = author
    @user = user

    mail :to => @tag_creator.email, :subject => "#{author.name} has approved your tag!"
  end

  def tag_photo_removed_to_creator(tag_creator,photo,author,user)
    @photo = photo
    @tag_creator = tag_creator
    @author = author
    @user = user

    mail :to => @tag_creator.email, :subject => "#{author.name} has approved you tag!"
  end
end
