module Postwall
  include ActiveSupport
  protected
  def post_wall(post, path)
    user_wall = UserWall.new
    user_wall_link = UserWallLink.new()
    user_wall.user_id = post.user.id
    user_wall.user_id_post = post.user.id
    user_wall.content = "A new post on #{post.post_category.name}"
    user_wall.save
    user_wall_link.link = path
    user_wall_link.title = post.title
    user_wall_link.sub_content = post.description
    user_wall.user_wall_link = user_wall_link
    user_wall.save
  end
end