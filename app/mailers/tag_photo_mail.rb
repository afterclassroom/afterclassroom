class TagPhotoMail < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
  default_url_options[:host] = "afterclassroom.com"
  def inform_creator_to_wait_case1(photo, current_user)
    @photo = photo
    @user = current_user
#    mail :to => current_user.email, :subject => "Please wait for #{@photo.user.name} to authorize your tag"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{@photo.user.name} to authorize your tag"
  end
  def inform_author_to_authorize_case1(photo, current_user)
    @photo = photo
    @user = current_user
#    mail :to => photo.user.email, :subject => "New tag on your photo"
    mail :to => "datefield@yahoo.com", :subject => "New tag on your photo"
  end
  def inform_creator_to_wait_case2(photo, current_user)
    @photo = photo
    @user = current_user
#    mail :to => current_user.email, :subject => "Please wait for #{@video.user.name} to authorize your tag"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{photo.user.name} to authorize your tag"
  end
  def inform_author_to_authorize_case2(photo, current_user)
    @photo = photo
    @user = current_user
#    mail :to => photo.user.email, :subject => "New tag on your photo"
    mail :to => "datefield@yahoo.com", :subject => "New tag on your photo"
  end
  def inform_creator_to_wait_case3(photo, user,tag_creator)
    @photo = photo
    @user = user
    @tag_creator=tag_creator
#    mail :to => current_user.email, :subject => "Please wait for #{photo.user.name} to authorize your tag"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{photo.user.name} to authorize your tag"
  end
  def inform_author_to_authorize_case3(photo, u,current_user)
    @photo = photo
    @user = u
    @current_user = current_user
#    mail :to => @photo.user.email, :subject => "New tag on your video"
    mail :to => "datefield@yahoo.com", :subject => "New tag on your video"
  end
  def inform_user_been_tagged_by_author(photo, user)
    @photo = photo
    @user= user
#    mail :to => user.email, :subject => "You have been tagged!"
    mail :to => "datefield@yahoo.com", :subject => "You have been tagged!"    
  end
  def inform_creator_self_tag_success(photo,creator)
    @photo = photo
    @creator = creator
#    mail :to => @creator.email, :subject => "You have been tagged!"
    mail :to => "datefield@yahoo.com", :subject => "You have been tagged!"
  end
  def inform_author_creator_self_tag_success(photo,creator)
    @photo = photo
    @creator = creator
#    mail :to => photo.user.email, :subject => "New tag on your photo"
    mail :to => "datefield@yahoo.com", :subject => "New tag on your photo"
  end
  def inform_creator_tag_of_author_success(photo,creator)
    @photo = photo
    @creator = creator
#    mail :to => @creator.email, :subject => "You added a new tag of #{photo.user.name}!"
    mail :to => "datefield@yahoo.com", :subject => "You added a new tag of #{photo.user.name}!"
  end
  def inform_author_tag_of_author_success(photo,creator)
    @photo = photo
    @creator = creator
#    mail :to => photo.user.email, :subject => "You have been tagged!"
    mail :to => "datefield@yahoo.com", :subject => "You have been tagged!"
  end
  

end
