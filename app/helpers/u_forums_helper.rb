module UForumsHelper

  def show_share_setting(user)
    pr = user.ufo_default
    val = pr ? pr.share_to_index : 0
    select_tag "ufo_setting", options_for_select(OPTIONS_SETTING, val), :class => "menuPrivate"
  end

  def show_tolounge_setting(user)
    pr = user.ufo_default
    val = pr ? pr.post_lounge : 0 #0 is NO,1 id YES
    lounge_setting = [["No", false], ["Yes", true]]
    select_tag "lounge_setting", options_for_select(lounge_setting, val), :class => "menuPrivate", :style => "width: 130px"
  end

  def show_share_custom(ufo)
    @custom = ufo.ufo_custom
    # val = pr ? pr.share_to_index : 0
    # select_tag "ufo_setting", options_for_select(OPTIONS_SETTING, val), :class => "menuPrivate"

    if (@custom != nil)
      @testtxt = 'co ton tai'
    end
    @testtxt
  end



end
