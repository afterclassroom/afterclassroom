class TagMusicMail < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
  default_url_options[:host] = "afterclassroom.com"
  
  def inform_creator_to_wait_case1(music_album, current_user)
    @music_album = music_album
    @user = current_user
#    mail :to => current_user.email, :subject => "Please wait for #{@music_album.user.name} to authorize your invitation"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{@music_album.user.name} to authorize your invitation"
  end
  def inform_author_to_authorize_case1(music_album, current_user)
    @music_album = music_album
    @user = current_user
#    mail :to => music_album.user.email, :subject => "New invitation on your music album"
    mail :to => "datefield@yahoo.com", :subject => "New invitation on your music album"
  end
  def inform_creator_to_wait_case2(music_album, current_user)
    @music_album = music_album
    @user = current_user
#    mail :to => current_user.email, :subject => "Please wait for #{music_album.user.name} to authorize your invitation"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{music_album.user.name} to authorize your invitation"
  end
  def inform_author_to_authorize_case2(music_album, current_user)
    @music_album = music_album
    @user = current_user
#    mail :to => music_album.user.email, :subject => "New invitation on your music album"
    mail :to => "datefield@yahoo.com", :subject => "New invitation on your music album"
  end
  def inform_creator_to_wait_case3(music_album, user,tag_creator)
    @music_album = music_album
    @user = user
    @tag_creator=tag_creator
#    mail :to => current_user.email, :subject => "Please wait for #{music_album.user.name} to authorize your invitation"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{music_album.user.name} to authorize your invitation"
  end
  def inform_author_to_authorize_case3(music_album, u,current_user)
    @music_album = music_album
    @user = u
    @current_user = current_user
#    mail :to => music_album.user.email, :subject => "New tag on your music album"
    mail :to => "datefield@yahoo.com", :subject => "New tag on your music album"
  end
  def inform_user_been_tagged_by_author(music_album, user)
    @music_album = music_album
    @user = user
#    mail :to => user.email, :subject => "You have been invited!"
    mail :to => "datefield@yahoo.com", :subject => "You have been invited!"
  end
  def inform_creator_self_tag_success(music_album,creator)
    @music_album = music_album
    @creator = creator
#    mail :to => @creator.email, :subject => "You have been invited!"
    mail :to => "datefield@yahoo.com", :subject => "You have been invited!"
  end
  def inform_author_creator_self_tag_success(music_album,creator)
    @music_album = music_album
    @creator = creator
#    mail :to => music_album.user.email, :subject => "New audience on your music album"
    mail :to => "datefield@yahoo.com", :subject => "New audience on your music album"
  end
  def inform_creator_tag_of_author_success(music_album,creator)
    @music_album = music_album
    @creator = creator
#    mail :to => @creator.email, :subject => "You sent a new invitation to #{music_album.user.name}!"
    mail :to => "datefield@yahoo.com", :subject => "You sent a new invitation to #{music_album.user.name}!"
  end
  def inform_author_tag_of_author_success(music_album,creator)
    @music_album = music_album
    @creator = creator
#    mail :to => music_album.user.email, :subject => "You have been tagged!"
    mail :to => "datefield@yahoo.com", :subject => "You have been invited!"
  end
  def inform_creator_tag_of_user_success(music_album,creator,u)
    @music_album = music_album
    @creator = creator
    @user = u
#    mail :to => creator.email, :subject => "You sent a new invitation of #{u.name}!"
    mail :to => "datefield@yahoo.com", :subject => "You sent a new invitation of #{u.name}!"
  end
  def inform_author_tag_of_user_success(music_album,current_user,u)
    @music_album = music_album
    @creator = current_user
    @user = u
#    mail :to => music_album.user.email, :subject => "New invitation on your music album"
    mail :to => "datefield@yahoo.com", :subject => "New invitation on your music album"
  end
  def inform_user_been_tagged(music_album,current_user,u)
    @music_album = music_album
    @creator = current_user
    @user = u
#    mail :to => u.email, :subject => "You have been invited to a music album!"
    mail :to => "datefield@yahoo.com", :subject => "You have been invited to a music album!"
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def inform_creator_own_tag_accepted(music_album,tag_creator)
    @music_album=music_album
    @tag_creator=tag_creator
#    mail :to => tag_creator.email, :subject => "Your invitation has been authorized!"
    mail :to => "datefield@yahoo.com", :subject => "Your invitation has been authorized!"
  end
  def inform_creator_author_tag_accepted(music_album,tag_creator)
    @music_album=music_album
    @tag_creator=tag_creator
#    mail :to => tag_creator.email, :subject => "Your tag of #{music_album.user.name} has been authorized!"
    mail :to => "datefield@yahoo.com", :subject => "Your tag of #{music_album.user.name} has been authorized!"
  end
  def inform_creator_user_tag_accepted(music_album,tag_creator,u)
    @music_album=music_album
    @tag_creator=tag_creator
    @user = u
#    mail :to => tag_creator.email, :subject => "Your tag of #{u.name} has been authorized!"
    mail :to => "datefield@yahoo.com", :subject => "Your tag of #{u.name} has been authorized!"
  end
  def inform_user_tag_created(music_album,tag_creator,u)
    @music_album=music_album
    @tag_creator=tag_creator
    @user = u
#    mail :to => u.email, :subject => "You have been tagged!"
    mail :to => "datefield@yahoo.com", :subject => "You have been tagged!"
  end
  
end

