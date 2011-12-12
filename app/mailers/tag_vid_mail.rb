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
  def inform_creator_to_wait_case3(video, user)
    @video = video
    @user = user
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
  
  
end
