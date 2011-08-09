module Postwall
  include ActiveSupport
  include TruncateHtmlHelper
  include ApplicationHelper
  
  protected
  def post_wall(post)
    class_name = post.class.name
    case class_name
      when "PhotoAlbum"
        content = "Add new photo album <a href='#{show_album_user_photos_path(post.user, :photo_album_id => post)}' target='_blank'>#{post.name}</a>"
      when "Photo"
        content = "Add new photo to album: <a href='#{show_album_user_photos_path(post.photo_album.user, :photo_album_id => post.photo_album)}' target='_blank'>#{post.photo_album.name}</a>"
      when "MusicAlbum"
        content = "Add new music album <a href='#{play_list_user_musics_path(post.user, :music_album_id => post)}' target='_blank'>#{post.name}</a>"
      when "Music"
        content = "Add new music to album: <a href='#{play_list_user_musics_path(post.music_album.user, :music_albumds_id => post.music_album)}' target='_blank'>#{post.music_album.name}</a>"
      when "Video"
        content = "Add new video: <a href='#{user_video_path(post.user, post)}' target='_blank'>#{post.title}</a>"
      when "Story"
        content = "Post a story"
      else
        content = "Add new post on #{post.post_category.name}"
    end
    user_wall_post = UserWallPost.new()
    user_wall_post.post_type = class_name
    user_wall_post.post_id = post.id
    user_wall = UserWall.new
    user_wall.user_id = post.user.id
    user_wall.user_id_post = post.user.id
    user_wall.content = content
    user_wall.user_wall_post = user_wall_post
    user_wall.save
  end
end