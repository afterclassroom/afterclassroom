class TagVidMail < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
  default_url_options[:host] = "afterclassroom.com"
  
  def inform_creator_to_wait_case1(video, current_user)
    @video = video
    @user = current_user
#    mail :to => current_user.email, :subject => "Please wait for #{@video.user.name} to authorize your tag"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{@video.user.name} to authorize your tag"
  end
  def inform_creator_to_wait_case2(video, current_user)
    @video = video
    @user = current_user
#    mail :to => current_user.email, :subject => "Please wait for #{@video.user.name} to authorize your tag"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{@video.user.name} to authorize your tag"
  end
  def inform_creator_to_wait_case3(video, user,tag_creator)
    @video = video
    @user = user
    @tag_creator=tag_creator
#    mail :to => current_user.email, :subject => "Please wait for #{@video.user.name} to authorize your tag"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{@video.user.name} to authorize your tag"
  end
  def inform_author_to_authorize_case1(video, current_user)
    @video = video
    @user = current_user
#    mail :to => video.user.email, :subject => "New tag on your video"
    mail :to => "datefield@yahoo.com", :subject => "New tag on your video"
  end
  def inform_author_to_authorize_case2(video, current_user)
    @video = video
    @user = current_user
#    mail :to => video.user.email, :subject => "New tag on your video"
    mail :to => "datefield@yahoo.com", :subject => "New tag on your video"
  end
  def inform_author_to_authorize_case3(video, u,current_user)
    @video = video
    @user = u
    @current_user = current_user
#    mail :to => video.user.email, :subject => "New tag on your video"
    mail :to => "datefield@yahoo.com", :subject => "New tag on your video"
  end
  
  def inform_user_been_tagged_by_author(video, user)
    @video=video
    @user= user
#    mail :to => user.email, :subject => "You have been tagged!"
    mail :to => "datefield@yahoo.com", :subject => "You have been tagged!"
    
  end
  
  def inform_creator_self_tag_success(video,creator)
    @video = video
    @creator = creator
    #mail :to => @creator.email, :subject => "You have been tagged!"
    mail :to => "datefield@yahoo.com", :subject => "You have been tagged!"
  end
  
  
end
