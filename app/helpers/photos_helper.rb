# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module PhotosHelper
  def new_photo_path_with_session_information()

    session_key = ActionController::Base.session_options[:key]

    user_photos_path(current_user, session_key => cookies[session_key], request_forgery_protection_token => form_authenticity_token)

  end
end
