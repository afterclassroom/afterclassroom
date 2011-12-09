module UForumsHelper

  def show_share_setting(user)
    pr = user.ufo_default
    val = pr ? pr.share_to_index : 0
    select_tag "ufo_setting", options_for_select(OPTIONS_SETTING, val), :class => "menuPrivate", :style => "width: 130px"
  end

  def show_tolounge_setting(user)
    pr = user.ufo_default
    val = pr ? pr.post_lounge : 0 #0 is NO,1 id YES
    lounge_setting = [["No", false], ["Yes", true]]
    select_tag "lounge_setting", options_for_select(lounge_setting, val), :class => "menuPrivate", :style => "width: 130px"
  end

  def show_share_custom(ufo)
    pr = ufo.ufo_custom

    val = pr ? pr.share_to_index : 0
    select_tag "ufo_setting", options_for_select(OPTIONS_SETTING, val), :class => "menuPrivate"

  end

  def show_tolounge_custom(ufo)
    pr = ufo.ufo_custom

    val = pr ? pr.post_lounge : 0 #0 is NO,1 id YES
    lounge_setting = [["No", false], ["Yes", true]]
    select_tag "lounge_setting", options_for_select(lounge_setting, val), :class => "menuPrivate", :style => "width: 130px"
  end

  def ufo_image_post(ctrl_name, post)
    file_path = post.ufo_attach_file_name
    if post.ufo_attach_content_type =~ /^image.*/
      path = post.ufo_attach.url
    else
      file_ext = File.extname(file_path).delete(".").downcase if file_path
      path = "/images/icons/file_type/#{file_ext}.png"
    end
    
    image_tag path, :style => "height: 45px; width: 45px;"
  end
  def ufocmt_image_post(ctrl_name, post)
    file_path = post.ucmt_attach_file_name
    if post.ucmt_attach_content_type =~ /^image.*/
      path = post.ucmt_attach.url
    else
      file_ext = File.extname(file_path).delete(".").downcase if file_path
      path = "/images/icons/file_type/#{file_ext}.png"
    end
    
    image_tag path, :style => "height: 45px; width: 45px;"
  end

end
