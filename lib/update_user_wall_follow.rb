module UpdateUserWallFollow
  include ActiveSupport
  protected
  def update_user_wall_follow(wall, user)
  	wall.user_wall_follows.each do |f|
				if f.count_update == USERWALLFOLLOW_MAX
					f.destroy
				else
					f.count_update = f.count_update
				end
			end
		# UserWall follow
				user_wall_follow = UserWallFollow.find_or_create_by_user_id_and_user_wall_id(:user_id => user.id, :user_wall_id => wall.id)
				user_wall_follow.count_update = 0
				user_wall_follow.save
  end
end
