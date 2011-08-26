module LearnToolsHelper
  def show_friend_player (tool)
    @count = 0
    tool.my_tools.each do |mt|
      if current_user.user_friends.include?(mt.user)
        @count = @count + 1
      end
    end
    @count
  end
  def display_friend_player (tool)
    fr_users = []
    tool.my_tools.each do |mt|
      if current_user.user_friends.include?(mt.user)
        fr_users << mt.user
      end
    end
    fr_users #return this array
  end
  
  def display_fan (tool)
    fan_ids = tool.fans.collect{|f| f.user_id}

    fan_results = User.ez_find(:all) do |user|
      user.id === fan_ids
    end
    
    fan_results #return this array
  end
  
  def show_tool_fan_register(tool)
    str = ""
    if !logged_in?
      str = link_to_require_login(raw("<span>Become a Fan</span>"))
    else
      if tool.fans.map(&:user_id).include?(current_user.id)
        str = link_to raw("<span>You are a fan</span>"), "javascript:;"
      else
        str = link_to( content_tag(:span, "Become a Fan"), {:controller => "learn_tools", :action => "become_a_fan", :tool_id => tool.id  }, :remote => true ,:method => :get)
      end
    end
    return str
  end 
  
  def is_my_tool(tool)
    result = nil
    if current_user.my_tools.where("learntool_id = ?", tool.id).size > 0
      result = true
    else
      result = false
    end
    result #return this value
  end
  
end
