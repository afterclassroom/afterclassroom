class TagStoryMail < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
  default_url_options[:host] = "afterclassroom.com"

  def inform_creator_to_wait_case1(story, current_user)
    @story = story
    @user = current_user
#    mail :to => current_user.email, :subject => "Please wait for #{@story.user.name} to authorize your invitation"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{@story.user.name} to authorize your invitation"
  end
  def inform_author_to_authorize_case1(story, current_user)
    @story = story
    @user = current_user
#    mail :to => @story.user.email, :subject => "New tag on your invitation"
    mail :to => "datefield@yahoo.com", :subject => "New tag on your invitation"
  end
  def inform_creator_to_wait_case2(story, current_user)
    @story = story
    @user = current_user
#    mail :to => current_user.email, :subject => "Please wait for #{@story.user.name} to authorize your tag"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{@story.user.name} to authorize your invitation"
  end
  def inform_author_to_authorize_case2(story, current_user)
    @story = story
    @user = current_user
#    mail :to => story.user.email, :subject => "New invitation on your story"
    mail :to => "datefield@yahoo.com", :subject => "New invitation on your story"
  end
  def inform_creator_to_wait_case3(story, user,tag_creator)
    @story = story
    @user = user
    @tag_creator=tag_creator
#    mail :to => current_user.email, :subject => "Please wait for #{@story.user.name} to authorize your invitation"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{@story.user.name} to authorize your invitation"
  end
  def inform_author_to_authorize_case3(story, u,current_user)
    @story = story
    @user = u
    @current_user = current_user
    mail :to => "datefield@yahoo.com", :subject => "New invitation on your story"
  end

end
