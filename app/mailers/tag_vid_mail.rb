class TagVidMail < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
  default_url_options[:host] = "afterclassroom.com"
  
  def inform_creator_to_wait(video, current_user)
    @video = video
    @user = current_user
    mail :to => current_user.email, :subject => "Please wait for #{@video.user.name} to authorize your tag"
  end
  def inform_author_to_authorize(video, current_user)
    @video = video
    @user = current_user
    mail :to => video.user.email, :subject => "New tag on your video"
  end
  
  
end
