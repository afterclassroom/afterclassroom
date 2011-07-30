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
end
