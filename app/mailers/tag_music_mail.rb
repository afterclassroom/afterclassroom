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
  
end

