class TagPhotoMail < ActionMailer::Base
  default :from => "#{Setting.get(:support_name)} <#{Setting.get(:support_email)}>"
  default_url_options[:host] = "afterclassroom.com"
  def inform_creator_to_wait_case1(photo, current_user)
    @photo = photo
    @user = current_user
#    mail :to => current_user.email, :subject => "Please wait for #{@photo.user.name} to authorize your tag"
    mail :to => "datefield@yahoo.com", :subject => "Please wait for #{@photo.user.name} to authorize your tag"
  end
end
