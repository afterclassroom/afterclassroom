# © Copyright 2009 AfterClassroom.com — All Rights Reserved
module UForumsHelper

  def show_share_setting(user)
    pr = user.ufo_default
    val = pr ? pr.share_to_index : 0
    select_tag "ufo_setting", options_for_select(OPTIONS_SETTING, val), :class => "menuPrivate"
  end


end
