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
  
  def learntool_to_dev(current_user, tool,title,message_str)
    @title = title
    @message_str = message_str
    @tool = tool
    @current_user = current_user
    mail :to => tool.user.email, :subject => "You've got mail from #{current_user.name}"
  end




  

  def vid_cmt_added(user,video,content,cmt_author)
    @video = video
    @content = content
    @cmt_author = cmt_author
    @user = user
    mail :to => user.email, :subject => "#{cmt_author.name} has added new comment for video"
  end
  #END SEND MAIL TAG VIDEO


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
    mail :to => user.email, :subject => "#{cmt_author.name} has added new comment for photo"
  end



  #BEGIN send mail for music tag
  def music_cmt_added(user,mus_album,content,cmt_author)
    @mus_album = mus_album
    @content = content
    @cmt_author = cmt_author
    @user = user
    #user.email
    mail :to => user.email, :subject => "#{cmt_author.name} has added new comment for music album #{@mus_album.name}"
  end
  #END send mail for music tag

  #BEGIN send mail for story tag

  
  def tag_story_removed(user,story,author)
    @story = story
    @user = user
    @author = author
    mail :to => @user.email, :subject => "#{author.name} has removed you from story readers!"
  end

  def story_cmt_added(user,story,content,cmt_author)
    @story = story
    @content = content
    @cmt_author = cmt_author
    @user = user
    mail :to => user.email, :subject => "#{cmt_author.name} has added new comment for story"
  end

  #END send mail for story tag

  def tag_music_removed(user,mus_album,author)
    @mus_album = mus_album
    @user = user
    @author = author
    mail :to => @user.email, :subject => "#{author.name} has removed you from music album listeners!"
  end

end
