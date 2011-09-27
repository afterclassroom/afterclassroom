module Postwall
  include ActiveSupport
  include TruncateHtmlHelper
  include ApplicationHelper
  
  protected
  def post_wall(post)
    class_name = post.class.name
    case class_name
      when "PhotoAlbum"
        user_id = post.user.id
        content = "Add new photo album <a href='#{show_album_user_photos_path(post.user, :photo_album_id => post)}' target='_blank'>#{post.name}</a>"
      when "Photo"
        user_id = post.user.id
        content = "Add new photo to album: <a href='#{show_album_user_photos_path(post.photo_album.user, :photo_album_id => post.photo_album)}' target='_blank'>#{post.photo_album.name}</a>"
      when "MusicAlbum"
        user_id = post.user.id
        content = "Add new music album <a href='#{play_list_user_musics_path(post.user, :music_album_id => post)}' target='_blank'>#{post.name}</a>"
      when "Music"
        user_id = post.user.id
        content = "Add new music to album: <a href='#{play_list_user_musics_path(post.music_album.user, :music_album_id => post.music_album)}' target='_blank'>#{post.music_album.name}</a>"
      when "Video"
        user_id = post.user.id
        content = "Add new video: <a href='#{user_video_path(post.user, post)}' target='_blank'>#{post.title}</a>"
      when "Story"
        user_id = post.user.id
        content = "Post a story"
      when "Learntool"
        user_id = post.user.id
        content = "Post a Learning Tool"
      else
        content = "Add new post on #{post.post.post_category.name}"
        user_id = post.post.user.id
    end
    create_wall(user_id, class_name, post.id, content)
  end
  
  def del_post_wall(post)
    user_wall_post = UserWallPost.find_by_post_type_and_post_id(post.class.name, post.id)
    if user_wall_post
      user_wall_id = user_wall_post.user_wall_id
      user_wall = UserWall.find(user_wall_id)
      user_wall.destroy if user_wall
    end
  end
  
  def create_wall(user_id, class_name, id, content)
    user_wall_post = UserWallPost.new()
    user_wall_post.post_type = class_name
    user_wall_post.post_id = id
    user_wall = UserWall.new
    user_wall.user_id = user_id
    user_wall.user_id_post = user_id
    user_wall.content = content
    user_wall.user_wall_post = user_wall_post
    user_wall.save
  end
end