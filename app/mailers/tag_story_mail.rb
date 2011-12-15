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
#    mail :to => @story.user.email, :subject => "New invitation on your story"
    mail :to => "datefield@yahoo.com", :subject => "New invitation on your story"
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
  def inform_user_been_tagged_by_author(story, user)
    @story = story
    @user= user
#    mail :to => user.email, :subject => "You have been invited!"
    mail :to => "datefield@yahoo.com", :subject => "You have been invited!"
  end
  def inform_author_creator_self_tag_success(story,creator)
    @story = story
    @creator = creator
#    mail :to => story.user.email, :subject => "New invitation on your story"
    mail :to => "datefield@yahoo.com", :subject => "New invitation on your story"
  end
  def inform_author_tag_of_author_success(story,creator)
    @story = story
    @creator = creator
#    mail :to => story.user.email, :subject => "You have been invited!"
    mail :to => "datefield@yahoo.com", :subject => "You have been invited!"
  end
  def inform_author_tag_of_user_success(story,current_user,u)
    @story = story
    @creator = current_user
    @user = u
#    mail :to => story.user.email, :subject => "New invitation on your story"
    mail :to => "datefield@yahoo.com", :subject => "New invitation on your story"
  end
  def inform_user_been_tagged(story,current_user,u)
    @story = story
    @creator = current_user
    @user = u
#    mail :to => u.email, :subject => "You have been invited on a story"
    mail :to => "datefield@yahoo.com", :subject => "You have been invited on a story"
  end
  def inform_creator_own_tag_accepted(story,tag_creator)
    @story = story
    @tag_creator=tag_creator
#    mail :to => tag_creator.email, :subject => "Your invitation has been authorized!"
    mail :to => "datefield@yahoo.com", :subject => "Your invitation has been authorized!"
  end
  def inform_creator_author_tag_accepted(story,tag_creator)
    @story=story
    @tag_creator=tag_creator
#    mail :to => tag_creator.email, :subject => "Your invitation of #{story.user.name} has been authorized!"
    mail :to => "datefield@yahoo.com", :subject => "Your invitation of #{story.user.name} has been authorized!"
  end
  def inform_creator_user_tag_accepted(story,tag_creator,u)
    @story = story
    @tag_creator=tag_creator
    @user = u
#    mail :to => tag_creator.email, :subject => "Your invitation of #{u.name} has been authorized!"
    mail :to => "datefield@yahoo.com", :subject => "Your invitation of #{u.name} has been authorized!"
  end
  def inform_user_tag_created(story,tag_creator,u)
    @story = story
    @tag_creator=tag_creator
    @user = u
#    mail :to => u.email, :subject => "You have been invited!"
    mail :to => "datefield@yahoo.com", :subject => "You have been invited!"
  end
  def inform_creator_own_tag_refused(story,tag_creator)
    @story = story
    @tag_creator = tag_creator
#    mail :to => tag_creator.email, :subject => "Your invitation has been refused!"
    mail :to => "datefield@yahoo.com", :subject => "Your invitation has been refused!"
  end
  def inform_creator_author_tag_refused(story,tag_creator)
    @story = story
    @tag_creator = tag_creator
#    mail :to => tag_creator.email, :subject => "Your invitation of #{story.user.name} has been refused!"
    mail :to => "datefield@yahoo.com", :subject => "Your invitation of #{story.user.name} has been refused!"
  end
  def inform_creator_user_tag_refused(story,tag_creator,u)
    @story=story
    @tag_creator=tag_creator
    @user = u
#    mail :to => tag_creator.email, :subject => "Your invitation of #{u.name} has been refused!"
    mail :to => "datefield@yahoo.com", :subject => "Your invitation of #{u.name} has been refused!"
    
  end

end
