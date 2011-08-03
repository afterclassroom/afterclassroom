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
    fan_users = []
    tool.my_tools.each do |mt|
      if mt.favorite
        fan_users << mt.user
      end
    end
    fan_users #return this array
  end
  
  def is_tool_favorite(tool,user)
    item = MyTool.find(:first, :conditions => [ "learntool_id = #{tool.id} AND user_id = #{user.id}"] )
    item ? item.favorite : false
  end
end
