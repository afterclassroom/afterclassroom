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
  
  def is_tool_favorite(tool,user)
    item = MyTool.find(:first, :conditions => [ "learntool_id = #{tool.id} AND user_id = #{user.id}"] )
    item ? item.favorite : false
  end
  
  def show_tool_fan_register(tool)
    str = ""
    if !logged_in?
      str = link_to_require_login(raw("<span>Become a Fan</span>"))
    else
      if tool.fans.map(&:user_id).include?(current_user.id)
        str = "You are a fan"
      else
        str = link_to_function raw("<span>Become a Fan</span>"), "become_tool_fan('#{become_a_fan_user_learn_tools_path(current_user)}?tool_id=#{tool.id}')"
      end
    end
    return str
  end  
  
end
